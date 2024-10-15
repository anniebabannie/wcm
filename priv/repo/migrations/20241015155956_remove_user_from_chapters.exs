defmodule Wcm.Repo.Migrations.RemoveUserFromChapters do
  use Ecto.Migration

  def change do
    alter table(:chapters) do
      remove :user_id
    end
  end
end
