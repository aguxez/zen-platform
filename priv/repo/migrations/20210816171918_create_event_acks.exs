defmodule Zen.Repo.Migrations.CreateEventAcks do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:event_acks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :last_block, :integer

      timestamps()
    end

    create unique_index(:event_acks, [:name])
  end
end
