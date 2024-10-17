defmodule Rolodex.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:contacts) do
      add :name, :text, null: false
      add :email, :citext
      add :favorite, :boolean, default: false, null: false
      add :notes, :text
      add :title, :string
      add :birthday, :date
      add :avatar_path, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:contacts, :email)
  end
end
