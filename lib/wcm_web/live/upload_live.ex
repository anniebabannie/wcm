# lib/my_app_web/live/upload_live.ex
defmodule WcmWeb.UploadLive do
  use WcmWeb, :live_view

  alias ExAws.S3
  alias Wcm.Pages

  @impl Phoenix.LiveView
  def mount(_params, %{"current_chapter" => current_chapter, "next_page_number" => next_page_number}, socket) do
    {:ok,
    socket
    |> assign(:uploaded_files, [])
    |> assign(:current_chapter, current_chapter)
    |> assign(:next_page_number, next_page_number)
    |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png .webp), max_entries: 2)}
  end

  def handle_info({:next_page_number, next_page_number}, socket) do
    {:noreply, assign(socket, next_page_number: next_page_number)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", %{"next_page_number" => next_page_number}, socket) do
    {:noreply, assign(socket, next_page_number: next_page_number)}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", %{"next_page_number" => next_page_number} = params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
        {:ok, contents} = File.read(path)
        mime_type = entry.client_type
        extension =
          case mime_type do
            "image/jpeg" -> ".jpg"
            "image/png" -> ".png"
            "image/gif" -> ".gif"
            "image/webp" -> ".webp"
            _ -> ""
          end

        img = "https://fly.storage.tigris.dev/wcm-dev/" <> Path.basename(path) <> extension
        S3.put_object("wcm-dev", Path.basename(path) <> extension, contents, content_type: entry.client_type) |> ExAws.request!

        case Pages.create_page(%{ img: img, chapter_id: socket.assigns[:current_chapter], number: next_page_number}) do
          {:ok, _} ->
            next_page_number = Pages.get_next_page_no(socket.assigns.current_chapter)
            Phoenix.PubSub.broadcast(Wcm.PubSub, "page_uploaded", {:page_uploaded, img})
            send(self(), {:next_page_number, next_page_number})
            {:ok, socket}

          {:error, changeset} ->
            socket =
              socket
                assign(:form, to_form(changeset))
            {:noreply, socket}
        end


      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
