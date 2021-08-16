defmodule Zen.Schema.Event.Ack do
  @moduledoc """
  Tracks the latest acknowledgement from an event. This way we can efficiently build queries
  """

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "event_acks" do
    field :name, :string
    field :last_block, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(ack, attrs) do
    ack
    |> cast(attrs, [:name, :last_block])
    |> validate_required([:name, :last_block])
    |> unique_constraint(:name)
  end
end
