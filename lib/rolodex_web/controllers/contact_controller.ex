defmodule RolodexWeb.ContactController do
  use RolodexWeb, :controller

  alias Rolodex.Contacts
  alias Rolodex.Contacts.Contact, warn: false

  def index(conn, _params) do
    contacts = Contacts.list_contacts()
    render(conn, :index, contacts: contacts)
  end

  def show(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    render(conn, :show, contact: contact)
  end

  def new(conn, _params) do
    changeset = Contacts.change_contact(%Contact{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"contact" => contact_params}) do
    case Contacts.create_contact(contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact created successfully.")
        |> redirect(to: ~p"/contacts/#{contact}")

      {:error, changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    changeset = Contacts.change_contact(contact)
    render(conn, :edit, contact: contact, changeset: changeset)
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Contacts.get_contact!(id)

    case Contacts.update_contact(contact, contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact updated successfully.")
        |> redirect(to: ~p"/contacts/#{contact}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, contact: contact, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    {:ok, _contact} = Contacts.delete_contact(contact)

    conn
    |> put_flash(:info, "Contact deleted successfully.")
    |> redirect(to: ~p"/")
  end
end
