defmodule Wcm.Pages.Page do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pages" do
    field :img, :string
    field :number, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(page, attrs) do
    page
    |> cast(attrs, [:number, :img])
    |> validate_required([:number, :img])
  end
end
