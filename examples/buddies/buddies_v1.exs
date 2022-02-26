defmodule Buddies do
  def new() do
    %{}
  end

  def add_entry(buddies, city, name) do
    Map.update(buddies, city, [name], fn names -> [name | names] end)
  end

  def entries(buddies, city) do
    Map.get(buddies, city, [])
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
