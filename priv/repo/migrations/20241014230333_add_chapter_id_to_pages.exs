defmodule Wcm.Repo.Migrations.AddChapterIdToPages do
  use Ecto.Migration

  def change do
    alter table(:pages) do
      add :chapter_id, references(:chapters, on_delete: :delete_all)
    end
  end
end
