defmodule WcmWeb.AdminLive do
  use WcmWeb, :live_view

  alias Wcm.Chapters
  alias Wcm.Chapters.Chapter
  alias Wcm.Pages
  alias Wcm.Pages.Page

  def mount(%{"id" => id_string}, _session, socket) do
    Phoenix.PubSub.subscribe(Wcm.PubSub, "page_uploaded")
    changeset = Chapter.changeset(%Chapter{})
    page_changeset = Page.changeset(%Page{})
    id = String.to_integer(id_string)
    socket =
      socket
        |> assign(:chapters, Chapters.list_chapters)
        |> assign(:pages, Pages.list_pages(id))
        |> assign(:form, to_form(changeset))
        |> assign(:page_form, to_form(page_changeset))
        |> assign(:current_chapter, id)
    {:ok, assign(socket, chapters: Chapters.list_chapters, editing_chapter_id: nil)}
  end


  def handle_info({:chapter_updated, _chapter_id}, socket) do
    # Refresh the list of chapters after an edit
    chapters = Chapters.list_chapters()
    {:noreply, assign(socket, chapters: chapters, editing_chapter_id: nil)}
  end

  def handle_info({:page_uploaded, _img}, socket) do
    IO.puts("Page uploaded")
    # Refresh the list of pages after an upload
    pages = Pages.list_pages(socket.assigns.current_chapter)
    {:noreply, assign(socket, pages: pages)}
  end

  def handle_event("submit", %{"chapter" => chapter_params}, socket) do

    case Chapters.create_chapter(chapter_params) do
      {:ok, chapter} ->
        socket =
          socket
            |> put_flash(:info, "Chapter created successfully.")
            |> assign(:chapters, [chapter | socket.assigns.chapters])

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
            assign(:form, to_form(changeset))
        {:noreply, socket}
    end
  end

  def handle_event("edit", %{"chapter_id" => chapter_id}, socket) do
    {:noreply, assign(socket, :editing_chapter_id, String.to_integer(chapter_id))}
  end

  def handle_event("page_submit", %{"page" => page_params}, socket) do
    params = page_params
      |> Map.put("chapter_id", socket.assigns.current_chapter)

    case Pages.create_page(params) do
      {:ok, page} ->
        socket =
          socket
            |> put_flash(:info, "page created successfully.")
            |> assign(:pages, [page | socket.assigns.pages])

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
            assign(:form, to_form(changeset))
        {:noreply, socket}
    end
  end

  def handle_event("delete_page", %{"page_id" => page_id}, socket) do
    page = Pages.get_page!(String.to_integer(page_id))
    Pages.delete_page(page)
    {:noreply, assign(socket, pages: Pages.list_pages(socket.assigns.current_chapter))}
  end

end
