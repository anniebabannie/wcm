defmodule Wcm.Pages do
  @moduledoc """
  The Pages context.
  """

  import Ecto.Query, warn: false
  alias Wcm.Repo

  alias Wcm.Pages.Page

  @doc """
  Returns the list of pages.

  ## Examples

      iex> list_pages()
      [%Page{}, ...]

  """
  def list_pages(chapter_id) do
    Repo.all(from(p in Page, where: p.chapter_id == ^chapter_id, order_by: [asc: p.number]))
  end

  @doc """
  Gets a single page.

  Raises `Ecto.NoResultsError` if the Page does not exist.

  ## Examples

      iex> get_page!(123)
      %Page{}

      iex> get_page!(456)
      ** (Ecto.NoResultsError)

  """
  def get_page!(id), do: Repo.get!(Page, id)

  def get_latest_page(chapter_id) do
    Repo.one(from(p in Page, where: p.chapter_id == ^chapter_id, order_by: [desc: p.number], limit: 1))
  end

  def get_next_page_no(chapter_id) do
    page = get_latest_page(chapter_id)
    if page == nil do
      1
    else
      page.number + 1
    end
  end

  @doc """
  Creates a page.

  ## Examples

      iex> create_page(%{field: value})
      {:ok, %Page{}}

      iex> create_page(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_page(attrs \\ %{}) do
    %Page{}
    |> Page.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a page.

  ## Examples

      iex> update_page(page, %{field: new_value})
      {:ok, %Page{}}

      iex> update_page(page, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a page.

  ## Examples

      iex> delete_page(page)
      {:ok, %Page{}}

      iex> delete_page(page)
      {:error, %Ecto.Changeset{}}

  """
  def delete_page(%Page{} = page) do
    Repo.delete(page)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking page changes.

  ## Examples

      iex> change_page(page)
      %Ecto.Changeset{data: %Page{}}

  """
  def change_page(%Page{} = page, attrs \\ %{}) do
    Page.changeset(page, attrs)
  end
end
