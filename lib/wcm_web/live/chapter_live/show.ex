defmodule WcmWeb.ChapterLive.Show do
  use WcmWeb, :live_view

  alias Wcm.Chapters

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:chapter, Chapters.get_chapter!(id))}
  end

  defp page_title(:show), do: "Show Chapter"
  defp page_title(:edit), do: "Edit Chapter"
end
