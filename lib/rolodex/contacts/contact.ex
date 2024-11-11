defmodule Rolodex.Contacts.Contact do
  use Ecto.Schema
  import Ecto.Changeset

  @titles ~w[Mr Mrs Miss Ms Dr Prof Rev Capt]a

  schema "contacts" do
    field :name, :string
    field :email, :string
    field :favorite, :boolean, default: false
    field :notes, :string
    field :title, Ecto.Enum, values: @titles
    field :birthday, :date

    timestamps(type: :utc_datetime)
  end

  def titles, do: @titles

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:name, :email, :favorite, :notes, :title, :birthday])
    |> validate_required([:name])
    |> validate_length(:name, max: 100)
    |> validate_length(:email, max: 100)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unsafe_validate_unique(:email, Rolodex.Repo)
    |> unique_constraint(:email)
    |> validate_change(:birthday, fn :birthday, birthday ->
      if Date.compare(birthday, Date.utc_today()) == :gt do
        [{:birthday, "can't be in the future"}]
      else
        []
      end
    end)
  end
end
