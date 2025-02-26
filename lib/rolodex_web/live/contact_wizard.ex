defmodule RolodexWeb.ContactWizard do
  use RolodexWeb, :live_view

  alias Rolodex.Contacts
  alias Rolodex.Contacts.Contact

  def mount(_params, _session, socket) do
    form = %Contact{} |> Contacts.change_contact() |> to_form()

    {:ok, assign(socket, form: form, step: 1)}
  end

  def render(assigns) do
    ~H"""
    <div class="max-w-md mx-auto mt-10 p-6 bg-white rounded-lg shadow-md">
      <h1 class="text-2xl font-bold mb-6">Add New Contact</h1>

      <div class="mb-4 flex justify-between">
        <div class="text-sm text-gray-500">
          Step {@step} of 3
        </div>
      </div>

      <.form
        id="contact-form"
        for={@form}
        phx-change="validate"
        phx-submit="submit-step"
        phx-auto-recover="recover"
      >
        <input type="hidden" name="current_step" value={@step} />

        <div class="mb-4">
          <div class={@step == 1 || "hidden"}>
            <.input field={@form[:name]} label="Contact name" type="text" />
          </div>
          <div class={@step == 2 || "hidden"}>
            <.input field={@form[:email]} label="Contact email" type="email" />
          </div>
          <div class={@step == 3 || "hidden"}>
            <.input field={@form[:notes]} label="Any notes?" type="textarea" />
          </div>
        </div>

        <div class="flex justify-between">
          <%= if @step == 1 do %>
            <div class="grow"></div>
          <% else %>
            <.button type="button" phx-click="prev">
              Back
            </.button>
          <% end %>

          <.button type="submit">
            <%= if @step == 3 do %>
              Save Contact
            <% else %>
              Next
            <% end %>
          </.button>
        </div>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"contact" => contact_params}, socket) do
    form =
      %Contact{}
      |> Contacts.change_contact(contact_params)
      |> to_form(action: :validate)

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("submit-step", %{"contact" => contact_params}, socket) do
    socket =
      if socket.assigns.step == 3 do
        case Contacts.create_contact(contact_params) do
          {:ok, contact} ->
            socket
            |> put_flash(:info, "Contact created successfully!")
            |> redirect(to: ~p"/contacts/#{contact}")

          {:error, changeset} ->
            assign(socket, form: to_form(changeset, action: :validate))
        end
      else
        changeset = Contacts.change_contact(%Contact{}, contact_params)
        form = to_form(changeset, action: :validate)

        if valid_step?(changeset, socket.assigns.step) do
          assign(socket, step: socket.assigns.step + 1, form: form)
        else
          assign(socket, form: form)
        end
      end

    {:noreply, socket}
  end

  def handle_event("recover", params, socket) do
    step =
      case Integer.parse(params["current_step"]) do
        {int, _} -> int
        :error -> 1
      end

    form =
      %Contact{}
      |> Contacts.change_contact(params["contact"])
      |> to_form()

    {:noreply, socket |> assign(form: form, step: step)}
  end

  def handle_event("prev", _params, socket) do
    {:noreply, update(socket, :step, &(&1 - 1))}
  end

  defp valid_step?(%{valid?: true}, _step), do: true

  defp valid_step?(changeset, step) do
    errors =
      case step do
        1 -> changeset.errors[:name]
        2 -> changeset.errors[:email]
        3 -> changeset.errors[:notes]
      end

    is_nil(errors)
  end
end
