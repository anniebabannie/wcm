defmodule Wcm.ChaptersTest do
  use Wcm.DataCase

  alias Wcm.Chapters

  describe "chapters" do
    alias Wcm.Chapters.Chapter

    import Wcm.ChaptersFixtures

    @invalid_attrs %{title: nil}

    test "list_chapters/0 returns all chapters" do
      chapter = chapter_fixture()
      assert Chapters.list_chapters() == [chapter]
    end

    test "get_chapter!/1 returns the chapter with given id" do
      chapter = chapter_fixture()
      assert Chapters.get_chapter!(chapter.id) == chapter
    end

    test "create_chapter/1 with valid data creates a chapter" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Chapter{} = chapter} = Chapters.create_chapter(valid_attrs)
      assert chapter.title == "some title"
    end

    test "create_chapter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chapters.create_chapter(@invalid_attrs)
    end

    test "update_chapter/2 with valid data updates the chapter" do
      chapter = chapter_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Chapter{} = chapter} = Chapters.update_chapter(chapter, update_attrs)
      assert chapter.title == "some updated title"
    end

    test "update_chapter/2 with invalid data returns error changeset" do
      chapter = chapter_fixture()
      assert {:error, %Ecto.Changeset{}} = Chapters.update_chapter(chapter, @invalid_attrs)
      assert chapter == Chapters.get_chapter!(chapter.id)
    end

    test "delete_chapter/1 deletes the chapter" do
      chapter = chapter_fixture()
      assert {:ok, %Chapter{}} = Chapters.delete_chapter(chapter)
      assert_raise Ecto.NoResultsError, fn -> Chapters.get_chapter!(chapter.id) end
    end

    test "change_chapter/1 returns a chapter changeset" do
      chapter = chapter_fixture()
      assert %Ecto.Changeset{} = Chapters.change_chapter(chapter)
    end
  end
end
