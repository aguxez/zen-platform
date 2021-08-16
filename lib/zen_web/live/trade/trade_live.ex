defmodule ZenWeb.TradeLive do
  @moduledoc false

  use ZenWeb, :live_view

  alias Zen.Schema.Trade
  alias Zen.Repo

  @impl true
  def mount(params, _session, socket) do
    conn_params = get_connect_params(socket)

    trade_changeset =
      if params["trade_id"] do
        Trade
        |> Repo.get(params["trade_id"])
        |> Trade.confirm_changeset(%{})
      else
        Ecto.Changeset.change(%Trade{}, %{})
      end

    if connected?(socket), do: send(self(), {:update_signer, conn_params["signer"]})

    {:ok,
     assign(socket, trade_changeset: trade_changeset, signer: "", trade_id: params["trade_id"])}
  end

  @impl true
  def handle_info({:update_signer, signer}, socket) do
    {:noreply, assign(socket, signer: signer)}
  end

  @impl true
  def handle_event("create_trade", params, socket) do
    changeset = Trade.changeset(%Trade{}, params["trade"])

    case Repo.insert(changeset) do
      {:ok, trade} ->
        new_socket =
          socket
          |> put_flash(:info, "Trade Created")
          |> redirect(to: Routes.show_path(socket, :show, trade.id))

        {:noreply, new_socket}

      {:error, changeset} ->
        {:noreply, assign(socket, trade_changeset: changeset)}
    end
  end

  @impl true
  def handle_event("confirm_trade", params, socket) do
    changeset =
      Trade
      |> Repo.get(socket.assigns.trade_id)
      |> Trade.confirm_changeset(params["trade"])

    case Repo.update(changeset) do
      {:ok, trade} ->
        new_socket =
          socket
          |> put_flash(:info, "Trade Confirmed")
          |> redirect(to: Routes.show_path(socket, :show, trade.id))

        {:noreply, new_socket}

      {:error, changeset} ->
        {:noreply, assign(socket, trade_changeset: changeset)}
    end
  end

  @impl true
  def handle_event("trade_init_params", _params, socket) do
    trade = Repo.get(Trade, socket.assigns.trade_id)

    case trade do
      nil ->
        {:noreply, socket}

      _ ->
        trade_params = Map.take(trade, [:id, :starter, :starter_token_address, :number_of_cells])
        {:noreply, push_event(socket, "trade_init_params", %{trade: trade_params})}
    end
  end
end
