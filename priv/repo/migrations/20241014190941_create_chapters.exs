defmodule Wcm.Repo.Migrations.CreateChapters do
  use Ecto.Migration

  def change do
    create table(:chapters) do
      add :title, :string

      timestamps(type: :utc_datetime)
    end
  end
end
