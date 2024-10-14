defmodule Wcm.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :number, :integer
      add :img, :text

      timestamps(type: :utc_datetime)
    end
  end
end
