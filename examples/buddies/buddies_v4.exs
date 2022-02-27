defmodule Buddies do
  def new(), do: MultiDict.new()

  def add_entry(buddies, entry) do
    MultiDict.add(buddies, entry.city, entry)
  end

  def entries(buddies, city) do
    MultiDict.get(buddies, city)
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
