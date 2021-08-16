defmodule Zen.Repo.Migrations.CreateTrades do
  use Ecto.Migration

  def change do
    create table(:trades, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :starter, :string, null: false
      add :receiver, :string
      add :starter_token_address, :string, null: false
      add :receiver_token_address, :string
      add :number_of_cells, :integer

      timestamps()
    end
  end
end
