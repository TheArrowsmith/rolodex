defmodule RolodexWeb.ContactHTML do
  use RolodexWeb, :html

  embed_templates "contact_html/*"

  def contact_avatar(assigns) do
    ~H"""
    <div class={"w-10 h-10 rounded-full #{contact_color(@contact)} flex items-center justify-center text-white text-lg font-semibold"}>
      {contact_initials(@contact)}
    </div>
    """
  end

  # Deterministically choose a "random" color based on the contact's name.
  defp contact_color(contact) do
    index = contact.name |> :erlang.phash2() |> rem(5)

    colors = ["bg-blue-500", "bg-red-500", "bg-green-500", "bg-orange-500", "bg-yellow-500"]
    Enum.at(colors, index)
  end

  defp contact_initials(contact) do
    contact.name
    |> String.replace(~r/[^0-9A-Za-z ]/, "")
    |> String.split()
    |> Enum.take(2)
    |> Enum.map(&String.first/1)
    |> Enum.join()
    |> String.upcase()
  end
end
