defmodule Wcm.Pages.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :img, :string
    field :number, :integer

    belongs_to :chapter, Wcm.Chapters.Chapter

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(page, attrs \\ %{}) do
    page
    |> cast(attrs, [:number, :img, :chapter_id])
    |> validate_required([:number, :img, :chapter_id])
  end
end
