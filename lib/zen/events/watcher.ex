defmodule Zen.Events.Watcher do
  @moduledoc """
  Process in charge of periodically querying events from the deployed SubGraph
  """

  use GenServer

  require Logger

  alias Zen.HTTP.Graph
  alias Zen.Repo
  alias Zen.Schema.Trade

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: :events_watcher)
  end

  @impl true
  def init(state) do
    :timer.send_interval(10_000, self(), :fetch_events)

    send(:events_watcher, :fetch_events)

    {:ok, state}
  end

  @impl true
  def handle_info(:fetch_events, state) do
    query = """
    query GetTradesEvents($tStartsBlock: Int = 0, $tAddedBlock: Int = 0) {
      tradeStarteds(where: {blockNumber_gte: $tStartsBlock}) {
        id
        blockNumber
        tradeId
        starter
        receiver
        starterContract
        receiverContract
      }
      tokenAddedToTrades(where: {blockNumber_gte: $tAddedBlock}) {
        id
        blockNumber
        tradeId
        owner
      }
    }
    """

    query
    |> Graph.post_query(%{tStartsBlock: 17_688_180, tAddedBlock: 17_688_180})
    |> concurrent_handle_events()

    {:noreply, state}
  end

  @impl true
  def handle_info({ref, res}, state) do
    IO.inspect({ref, res})
    {:noreply, state}
  end

  defp concurrent_handle_events({:ok, %{body: body}}) do
    Enum.each(body["data"], &take_events_by_name/1)
  end

  defp concurrent_handle_events(_), do: :ignore

  defp take_events_by_name({"tokenAddedToTrades", _events}) do
    # TODO: Implement
  end

  defp take_events_by_name({"tradeStarteds", events}) do
    Enum.each(events, fn event ->
      Task.Supervisor.start_child(Zen.Supervisors.EventsSupervisor, fn ->
        confirm_trade(event)
      end)
    end)
  end

  defp confirm_trade(event) do
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
end
