defmodule Zen.Repo.Migrations.CreateTradeAssets do
  use Ecto.Migration

  def change do
    create table(:trade_assets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :is_locked, :boolean, default: false, null: false
      add :trade_id, references(:trades, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:trade_assets, [:trade_id])
  end
end
