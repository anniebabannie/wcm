defmodule WcmWeb.ChapterLive.Index do
  use WcmWeb, :live_view

  alias Wcm.Chapters
  alias Wcm.Chapters.Chapter

  def mount(_params, _session, socket) do
    changeset = Chapter.changeset(%Chapter{})
    socket =
      socket
        |> assign(:chapters, Chapters.list_chapters)
        |> assign(:form, to_form(changeset))
    {:ok, assign(socket, chapters: Chapters.list_chapters, editing_chapter_id: nil)}
  end


  def handle_info({:chapter_updated, _chapter_id}, socket) do
    # Refresh the list of chapters after an edit
    chapters = Chapters.list_chapters()
    {:noreply, assign(socket, chapters: chapters, editing_chapter_id: nil)}
  end

  def handle_event("submit", %{"chapter" => chapter_params}, socket) do
    params = chapter_params
      |> Map.put("user_id", socket.assigns.current_user.id)

    case Chapters.create_chapter(params) do
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
end
