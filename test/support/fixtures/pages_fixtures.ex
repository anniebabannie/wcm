defmodule Wcm.PagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Wcm.Pages` context.
  """

  @doc """
  Generate a page.
  """
  def page_fixture(attrs \\ %{}) do
    {:ok, page} =
      attrs
      |> Enum.into(%{
        img: "some img",
        number: 42
      })
      |> Wcm.Pages.create_page()

    page
  end
end
