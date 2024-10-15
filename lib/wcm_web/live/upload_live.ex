# lib/my_app_web/live/upload_live.ex
defmodule WcmWeb.UploadLive do
  use WcmWeb, :live_view

  alias ExAws.S3
  alias Wcm.Pages

  @impl Phoenix.LiveView
  @spec mount(any(), any(), map()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, _session, socket) do
    # IO.inspect(socket.assigns[:current_chapter])
    {:ok,
    socket
    |> assign(:uploaded_files, [])
    |> assign(:current_chapter, 2)
    |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png .webp), max_entries: 2)}
  end

  @impl Phoenix.LiveView
  @spec handle_event(<<_::32, _::_*8>>, any(), any()) :: {:noreply, any()}
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    IO.inspect(socket.assigns[:current_chapter])
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
        mime_type = entry.client_type
        {:ok, contents} = File.read(path)
        IO.inspect(mime_type)
        extension =
          case mime_type do
            "image/jpeg" -> ".jpg"
            "image/png" -> ".png"
            "image/gif" -> ".gif"
            "image/webp" -> ".webp"
            _ -> ""
          end
        IO.puts("Uploading....")
        img = "https://fly.storage.tigris.dev/wcm-dev/" <> Path.basename(path) <> extension
        IO.inspect(img)
        S3.put_object("wcm-dev", Path.basename(path) <> extension, contents, content_type: entry.client_type) |> ExAws.request!

        case Pages.create_page(%{ img: img, chapter_id: socket.assigns[:current_chapter], number: 2}) do
          {:ok, _} ->
            socket =
              socket
                |> put_flash(:info, "page created successfully.")

            # {:noreply, socket}
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
