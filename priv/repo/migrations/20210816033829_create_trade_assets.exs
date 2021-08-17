defmodule Zen.Repo.Migrations.CreateTradeAssets do
  use Ecto.Migration

  def change do
    create table(:trade_assets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :is_locked, :boolean, default: false, null: false
      add :metadata_uri, :string
      add :token_id, :integer, null: false
      add :trade_id, references(:trades, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create unique_index(:trade_assets, [:trade_id, :token_id])
    create index(:trade_assets, [:trade_id])
  end
end
