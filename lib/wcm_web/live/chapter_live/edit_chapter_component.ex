# lib/my_app_web/live/chapter_edit_component.ex
defmodule WcmWeb.ChapterEditComponent do
  use WcmWeb, :live_component

  alias Wcm.Chapters

  def render(assigns) do
    ~H"""
    <div>
      <form phx-submit="save" phx-target={@myself}>
        <input type="text" name="title" value={@chapter.title} />
        <button type="submit">Save</button>
      </form>
    </div>
    """
  end

  def handle_event("save", %{"title" => title}, socket) do
    # Handle chapter save logic
    chapter = socket.assigns.chapter
    {:ok, _chapter} = Chapters.update_chapter(chapter, %{title: title})

    # Send a message back to the parent LiveView after save
    send(self(), {:chapter_updated, chapter.id})
    {:noreply, socket}
  end
end
