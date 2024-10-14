defmodule Wcm.Chapters.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chapters" do
    field :title, :string

    belongs_to :user, Wcm.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chapter, attrs \\ %{}) do
    chapter
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
