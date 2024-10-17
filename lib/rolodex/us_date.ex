defmodule Spoonme.USDate do
  @behaviour Ecto.Type

  @impl true
  def type, do: :date

  @impl true
  def cast(input) when is_binary(input) do
    date_regex = ~r/^\d{2}\/\d{2}\/\d{4}$/
    input = String.trim(input)

    if Regex.match?(date_regex, input) do
      [mm, dd, yyyy] = String.split(input, "/")

      {:ok, Date.from_iso8601!("#{yyyy}-#{mm}-#{dd}")}
    else
      :error
    end
  end

  @impl true
  def cast(%Date{} = date), do: {:ok, date}

  @impl true
  def load(value), do: {:ok, value}

  @impl true
  def dump(value), do: {:ok, value}

  @impl true
  def equal?(nil, nil), do: true

  @impl true
  def equal?(%Date{} = date1, %Date{} = date2), do: Date.compare(date1, date2) == :eq

  def equal?(_, _), do: false

  @impl true
  def embed_as(_), do: :self
end
