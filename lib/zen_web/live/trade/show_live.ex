defmodule ZenWeb.Trade.ShowLive do
  @moduledoc """
  Handles showing a trade
  """

  use ZenWeb, :live_view

  alias Zen.Repo
  alias Zen.Schema.Trade
  alias ZenWeb.Endpoint

  @impl true
  def mount(%{"trade_id" => trade_id}, _assigns, socket) do
    trade =
      Trade
      |> Repo.get(trade_id)
      |> subscribe_to_trade?()

    if trade && trade.receiver do
      send(self(), {:trade_confirmed, trade})
    end

    {:ok, assign(socket, trade: trade, trade_confirmed: false)}
  end

  @impl true
  def handle_info({:trade_confirmed, trade}, socket) do
    {:noreply, assign(socket, trade_confirmed: true, trade: trade)}
  end

  defp subscribe_to_trade?(nil), do: nil

  defp subscribe_to_trade?(trade) do
    Phoenix.PubSub.subscribe(Zen.PubSub, trade.id)
    trade
  end
end
