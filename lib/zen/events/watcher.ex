defmodule Zen.Events.Watcher do
  @moduledoc """
  Process in charge of periodically querying events from the deployed SubGraph
  """

  use GenServer

  import Ecto.Query, only: [from: 2]

  require Logger

  alias Ecto.Multi
  alias Zen.HTTP.Graph
  alias Zen.Repo
  alias Zen.Schema.{Trade, Trade.Asset, Event.Ack}

  @watchable_events [
    "tradeStarteds",
    "tokenAddedToTrades"
  ]

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: :events_watcher)
  end

  @impl true
  def init(state) do
    :timer.send_interval(10000, self(), :fetch_events)

    send(:events_watcher, :fetch_events)

    {:ok, state}
  end

  @impl true
  def handle_info(:fetch_events, state) do
    query = """
    query GetTradesEvents($tStartsBlock: Int = 0, $tAddedBlock: Int = 0) {
      tradeStarteds(where: {blockNumber_gt: $tStartsBlock}, orderBy: blockNumber, orderDirection: desc) {
        id
        blockNumber
        tradeId
        starter
        receiver
        starterContract
        receiverContract
      }
      tokenAddedToTrades(where: {blockNumber_gt: $tAddedBlock}, orderBy: blockNumber, orderDirection: desc) {
        id
        blockNumber
        tradeId
        tokenId
        cell
      }
    }
    """

    blocks = fetch_or_insert_event_blocks(@watchable_events)

    query
    |> Graph.post_query(%{
      tStartsBlock: blocks["tradeStarteds"],
      tAddedBlock: blocks["tokenAddedToTrades"]
    })
    |> concurrent_handle_events()

    {:noreply, state}
  end

  @impl true
  def handle_info({:ack_event, event_name, block_number}, state) do
    Ack
    |> Repo.get_by(name: event_name)
    |> Ack.changeset(%{last_block: block_number})
    |> Repo.update()

    {:noreply, state}
  end

  # This will try to pull the rows for `events` so we can build queries based in block numbers
  # if the row does not exist, we will insert it and set `last_block` to 0 according to module's schema
  defp fetch_or_insert_event_blocks(events) do
    acks = Repo.all(from(a in Ack, where: a.name in ^events))
    ack_names = Enum.map(acks, & &1.name)

    new_acks =
      events
      |> Enum.reject(&(&1 in ack_names))
      |> insert_events()

    (acks ++ new_acks)
    |> Enum.map(fn ack -> {ack.name, ack.last_block} end)
    |> Enum.into(%{})
  end

  defp insert_events([]), do: []

  defp insert_events(missed_events) do
    # insert the missed events if any
    missed_events
    |> Enum.reduce(Multi.new(), fn event_name, multi ->
      Multi.insert(multi, "#{event_name}_multi", Ack.changeset(%Ack{}, %{name: event_name}))
    end)
    |> Repo.transaction()
    |> case do
      {:ok, acks} -> Map.values(acks)
      _ -> []
    end
  end

  defp concurrent_handle_events({:ok, %{body: body}}) do
    Enum.each(body["data"], &take_events_by_name/1)
  end

  defp concurrent_handle_events(_), do: :ignore

  defp take_events_by_name({_, []}), do: :ignore

  defp take_events_by_name({"tokenAddedToTrades" = event_name, events}) do
    Logger.info("Handling #{length(events)} token adds")

    Zen.Supervisors.EventsSupervisor
    |> Task.Supervisor.async_stream(events, &add_token_to_trade/1, max_concurrency: 2)
    |> Stream.run()

    ack_event(event_name, events)
  end

  defp take_events_by_name({"tradeStarteds" = event_name, events}) do
    Logger.info("Handling #{length(events)} trade starts")

    Zen.Supervisors.EventsSupervisor
    |> Task.Supervisor.async_stream(events, &confirm_trade/1, max_concurrency: 2)
    |> Stream.run()

    ack_event(event_name, events)
  end

  defp confirm_trade(event) do
    Logger.info("Trying to confirm #{event["tradeId"]}")

    confirm_params = %{
      receiver: event["receiver"],
      receiver_token_address: event["receiverContract"]
    }

    with %Trade{receiver: nil} = trade <- Repo.get(Trade, event["tradeId"]),
         changeset <- Trade.confirm_changeset(trade, confirm_params),
         {:ok, updated_trade} <- Repo.update(changeset) do
      Phoenix.PubSub.broadcast(Zen.PubSub, updated_trade.id, {:trade_confirmed, updated_trade})
    end
  rescue
    _e in [Ecto.Query.CastError] ->
      # Probably we received a bad trade ID
      Logger.warn("Received an invalid trade ID for #{event["tradeId"]}")
      :ignore
  end

  defp add_token_to_trade(event) do
    IO.inspect(event)
    Logger.info("Trying to add token to #{event["tradeId"]}")

    asset_params = %{
      is_locked: true,
      trade_id: event["tradeId"],
      token_id: event["tokenId"]
    }

    with nil <- Repo.get_by(Asset, trade_id: event["tradeId"], token_id: event["tokenId"]),
         changeset <- Asset.changeset(%Asset{}, asset_params),
         {:ok, _asset} <- Repo.insert(changeset) do
      # TODO: Broadcast
    end
  end

  defp ack_event(event_name, [last_event | _]) do
    send(self(), {:ack_event, event_name, last_event["blockNumber"]})
  end
end
