defmodule WcmWeb.ChapterLive.FormComponent do
  use WcmWeb, :live_component

  alias Wcm.Chapters

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage chapter records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="chapter-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Chapter</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{chapter: chapter} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Chapters.change_chapter(chapter))
     end)}
  end

  @impl true
  def handle_event("validate", %{"chapter" => chapter_params}, socket) do
    changeset = Chapters.change_chapter(socket.assigns.chapter, chapter_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"chapter" => chapter_params}, socket) do
    save_chapter(socket, socket.assigns.action, chapter_params)
  end

  defp save_chapter(socket, :edit, chapter_params) do
    case Chapters.update_chapter(socket.assigns.chapter, chapter_params) do
      {:ok, chapter} ->
        notify_parent({:saved, chapter})

        {:noreply,
         socket
         |> put_flash(:info, "Chapter updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_chapter(socket, :new, chapter_params) do
    case Chapters.create_chapter(chapter_params) do
      {:ok, chapter} ->
        notify_parent({:saved, chapter})

        {:noreply,
         socket
         |> put_flash(:info, "Chapter created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
