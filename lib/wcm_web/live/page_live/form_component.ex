defmodule WcmWeb.PageLive.FormComponent do
  use WcmWeb, :live_component

  alias Wcm.Pages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage page records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="page-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:number]} type="number" label="Number" />
        <.input field={@form[:img]} type="text" label="Img" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Page</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{page: page} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Pages.change_page(page))
     end)}
  end

  @impl true
  def handle_event("validate", %{"page" => page_params}, socket) do
    changeset = Pages.change_page(socket.assigns.page, page_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"page" => page_params}, socket) do
    save_page(socket, socket.assigns.action, page_params)
  end

  defp save_page(socket, :edit, page_params) do
    case Pages.update_page(socket.assigns.page, page_params) do
      {:ok, page} ->
        notify_parent({:saved, page})

        {:noreply,
         socket
         |> put_flash(:info, "Page updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_page(socket, :new, page_params) do
    case Pages.create_page(page_params) do
      {:ok, page} ->
        notify_parent({:saved, page})

        {:noreply,
         socket
         |> put_flash(:info, "Page created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
