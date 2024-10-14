defmodule Wcm.PagesTest do
  use Wcm.DataCase

  alias Wcm.Pages

  describe "pages" do
    alias Wcm.Pages.Page

    import Wcm.PagesFixtures

    @invalid_attrs %{img: nil, number: nil}

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Pages.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Pages.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      valid_attrs = %{img: "some img", number: 42}

      assert {:ok, %Page{} = page} = Pages.create_page(valid_attrs)
      assert page.img == "some img"
      assert page.number == 42
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pages.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      update_attrs = %{img: "some updated img", number: 43}

      assert {:ok, %Page{} = page} = Pages.update_page(page, update_attrs)
      assert page.img == "some updated img"
      assert page.number == 43
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Pages.update_page(page, @invalid_attrs)
      assert page == Pages.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Pages.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Pages.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Pages.change_page(page)
    end
  end
end
