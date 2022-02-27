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

  def update_entry(buddies, entry_id, updater_fun) do
    case Map.fetch(buddies.entries, entry_id) do
      :error ->
        buddies

      {:ok, old_entry} ->
        new_entry = %{id: ^entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(buddies.entries, entry_id, new_entry)
        %Buddies{buddies | entries: new_entries}
    end
  end

  def delete_entry(buddies, entry_id) do
    new_entries = Map.filter(buddies.entries, fn {_, e} -> e.id != entry_id end)
    %Buddies{buddies | entries: new_entries}
  end
end

buddies =
  Buddies.new()
  |> Buddies.add_entry(%{city: "Palermo", name: "Vito"})
  |> Buddies.add_entry(%{city: "Bern", name: "Urs"})

Enum.each(buddies.entries, &IO.inspect/1)

buddies =
  buddies
  |> Buddies.delete_entry(2)
  |> Buddies.update_entry(1, fn e -> Map.put(e, :name, "Don Corleone") end)

Enum.each(buddies.entries, &IO.inspect/1)
