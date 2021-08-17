defmodule Zen.Schema.Trade.Asset do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, Ecto.ShortUUID, autogenerate: true}
  @foreign_key_type Ecto.ShortUUID
  schema "trade_assets" do
    field :is_locked, :boolean, default: false
    field :metadata_uri, :string
    field :token_id, :integer

    belongs_to(:trade, Zen.Schema.Trade)

    timestamps()
  end

  @doc false
  def changeset(asset, attrs) do
    asset
    |> cast(attrs, [:trade_id, :is_locked, :metadata_uri, :token_id])
    |> validate_required([:trade_id, :is_locked, :token_id])
    |> foreign_key_constraint(:trade_id)
  end
end
