defmodule Wcm.Chapters.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chapters" do
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(chapter, attrs \\ %{}) do
    chapter
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
