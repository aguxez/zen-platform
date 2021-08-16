defmodule ZenWeb.IndexLive do
  @moduledoc false

  use ZenWeb, :live_view

  import Ecto.Query, only: [from: 2]

  alias Zen.Repo
  alias Zen.Schema.Trade

  @impl true
  def render(assigns) do
    ~H"""
    <button id="web3-connect" class="btn btn-primary" phx-hook="ConnectWeb3">Connect Web3</button>

    <%= button "Create Trade", to: Routes.trade_path(@socket, :new), method: :get, class: "btn btn-primary" %>

    <hr/>

    <%= if @trades != [] do %>
      <table class="table">
        <tr>
          <th scope="col">Trade ID</th>
          <th scope="col">Trade Link</th>
          <th scope="col">Confirmed</th>
        </tr>

        <%= for trade <- @trades do %>
          <tr>
            <td> <%= trade.id %> </td>
            <td> <%= link "Link", to: Routes.show_path(@socket, :show, trade.id) %> </td>
            <td> <%= !!trade.receiver %> </td>
          </tr>
        <% end %>
      </table>
    <% else %>
      <h4>No trades have been created yet</h4>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    trades = Repo.all(from(t in Trade, order_by: [desc: :inserted_at]))

    {:ok, assign(socket, trades: trades)}
  end
end
