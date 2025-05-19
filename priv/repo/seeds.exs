# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rolodex.Repo.insert!(%Rolodex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rolodex.Contacts.Contact
alias Rolodex.Repo

tlds = ~w[com net org]

[
  "Jimi Hendrix",
  "Kirk Hammett",
  "John Petrucci",
  "Tom Morello",
  "John Frusciante",
  "Jimmy Page",
  "George Harrison",
  "Brian May",
  "Daron Malakian",
  "Mick Thomson",
  "Carlos Santana",
  "Jeff Beck",
  "Keith Richards",
  "Eric Clapton",
  "Eddie Van Halen",
  "Ace Frehley",
  "Slash",
  "David Gilmour",
  "Dave Mustaine",
  "Frank Zappa",
  "Kim Thayil"
]
|> Enum.each(fn name ->
  email = name |> String.downcase() |> String.replace(" ", ".")
  email = email <> "@example." <> Enum.random(tlds)

  favorite? = :rand.uniform() > 0.75

  # Generate a random date between 1940 and 1980:
  first = ~D[1940-01-01]
  last = ~D[1980-12-31]
  date = Date.add(first, Enum.random(0..Date.diff(last, first)))

  Repo.insert!(%Contact{
    name: name,
    email: email,
    favorite: favorite?,
    birthday: date,
    title: "Mr",
    notes: Faker.Lorem.paragraph()
  })
end)
