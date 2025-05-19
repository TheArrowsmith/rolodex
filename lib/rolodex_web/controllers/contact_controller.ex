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
    render(conn, :new)
  end

  def create(conn, params) do
    text(conn, inspect(params))
  end

  def edit(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    render(conn, :edit, contact: contact)
  end

  def update(conn, %{"id" => _id, "contact" => contact_params}) do
    text(conn, inspect(contact_params))
  end

  def delete(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    {:ok, _contact} = Contacts.delete_contact(contact)

    conn
    |> put_flash(:info, "Contact deleted successfully.")
    |> redirect(to: ~p"/")
  end
end
