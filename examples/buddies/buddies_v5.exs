defmodule Buddies do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %Buddies{}

  def add_entry(buddies, entry) do
    entry = Map.put(entry, :id, buddies.auto_id)
    new_entries = Map.put(buddies.entries, buddies.auto_id, entry)
    %Buddies{buddies | entries: new_entries, auto_id: buddies.auto_id + 1}
  end

  def entries(buddies, city) do
    buddies.entries
    |> Stream.filter(fn {_, entry} -> entry.city == city end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  defmodule Entry do
    defstruct city: nil, name: nil

    def new(city, name) do
      %Entry{city: city, name: name}
    end
  end
end

buddies =
  Buddies.new()
  |> Buddies.add_entry(Buddies.Entry.new("Rome", "Giorgio"))
  |> Buddies.add_entry(Buddies.Entry.new("Rome", "Matteo"))
  |> Buddies.add_entry(Buddies.Entry.new("Moscow", "Yuri"))
  |> Buddies.add_entry(Buddies.Entry.new("Moscow", "Ivan"))

Buddies.entries(buddies, "Rome")
|> Enum.each(&IO.inspect/1)
