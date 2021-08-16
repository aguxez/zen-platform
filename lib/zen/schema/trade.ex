defmodule Zen.Schema.Trade do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, Ecto.ShortUUID, autogenerate: true}
  @foreign_key_type Ecto.ShortUUID
  schema "trades" do
    field :number_of_cells, :integer
    field :receiver, :string
    field :receiver_token_address, :string
    field :starter, :string
    field :starter_token_address, :string

    has_many(:assets, __MODULE__.Asset)

    timestamps()
  end

  @doc false
  def changeset(trade, attrs) do
    trade
    |> cast(attrs, [
      :starter,
      :receiver,
      :starter_token_address,
      :receiver_token_address,
      :number_of_cells
    ])
    |> validate_required([
      :starter,
      :starter_token_address,
      :number_of_cells
    ])
  end

  def confirm_changeset(trade, params) do
    trade
    |> cast(params, [:receiver, :receiver_token_address])
    |> validate_required([:receiver, :receiver_token_address])
  end

  defp generate_id(%Ecto.Changeset{valid?: true} = changeset) do
    put_change(changeset, :id, do_generate_id())
  end

  defp generate_id(changeset), do: changeset

  defp do_generate_id do
    8
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end
end
