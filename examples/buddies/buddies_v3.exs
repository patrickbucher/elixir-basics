defmodule Buddies do
  def new(), do: MultiDict.new()

  def add_entry(buddies, entry) do
    MultiDict.add(buddies, entry.city, entry)
  end

  def entries(buddies, city) do
    MultiDict.get(buddies, city)
  end
end

buddies =
  Buddies.new()
  |> Buddies.add_entry(%{city: "Rome", name: "Giorgio"})
  |> Buddies.add_entry(%{city: "Rome", name: "Matteo"})
  |> Buddies.add_entry(%{city: "Moscow", name: "Yuri"})
  |> Buddies.add_entry(%{city: "Moscow", name: "Ivan"})

Buddies.entries(buddies, "Rome")
|> Enum.each(&IO.inspect/1)
