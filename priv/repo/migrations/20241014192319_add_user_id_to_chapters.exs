defmodule Wcm.Repo.Migrations.AddUserIdToChapters do
  use Ecto.Migration

  def change do
    alter table(:chapters) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
