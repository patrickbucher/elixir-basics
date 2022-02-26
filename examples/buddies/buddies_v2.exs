defmodule Buddies do
  def new(), do: MultiDict.new()

  def add_entry(buddies, city, name) do
    MultiDict.add(buddies, city, name)
  end

  def entries(buddies, city) do
    MultiDict.get(buddies, city)
  end
end

buddies =
  Buddies.new()
  |> Buddies.add_entry("Rome", "Giorgio")
  |> Buddies.add_entry("Rome", "Matteo")
  |> Buddies.add_entry("Moscow", "Yuri")
  |> Buddies.add_entry("Moscow", "Ivan")

Buddies.entries(buddies, "Rome")
|> Enum.each(&IO.puts/1)
