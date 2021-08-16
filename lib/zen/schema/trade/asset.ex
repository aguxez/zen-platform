defmodule Zen.Schema.Trade.Asset do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, Ecto.ShortUUID, autogenerate: true}
  @foreign_key_type Ecto.ShortUUID
  schema "trade_assets" do
    field :is_locked, :boolean, default: false

    belongs_to(:trade, Zen.Schema.Trade)

    timestamps()
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:is_locked])
    |> validate_required([:is_locked])
  end
end
