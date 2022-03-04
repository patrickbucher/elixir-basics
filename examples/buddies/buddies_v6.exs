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

defmodule BuddyServer do
  def start() do
    spawn(fn -> loop(Buddies.new()) end)
  end

  def add_entry(entry) do
    send(:buddy_server, {:add, entry})
  end

  def update_entry(entry_id, updater_fun) do
    send(:buddy_server, {:upd, entry_id, updater_fun})
  end

  def delete_entry(entry_id) do
    send(:buddy_server, {:del, entry_id})
  end

  def entries(city) do
    send(:buddy_server, {:entries, city, self()})

    receive do
      {:ok, entries} -> entries
    end
  end

  defp loop(buddies) do
    new_buddies =
      receive do
        {:add, entry} ->
          Buddies.add_entry(buddies, entry)

        {:upd, entry_id, updater_fun} ->
          Buddies.update_entry(buddies, entry_id, updater_fun)

        {:del, entry_id} ->
          Buddies.delete_entry(buddies, entry_id)

        {:entries, city, pid} ->
          send(pid, {:ok, Buddies.entries(buddies, city)})
          buddies
      end

    loop(new_buddies)
  end
end

pid = BuddyServer.start()
Process.register(pid, :buddy_server)

IO.puts("adding some buddies")
BuddyServer.add_entry(%{city: "Berlin", name: "Hans"})
BuddyServer.add_entry(%{city: "Berlin", name: "Hermann"})
BuddyServer.add_entry(%{city: "Palermo", name: "Vito"})

IO.puts("entries from Berlin")
Enum.each(BuddyServer.entries("Berlin"), &IO.inspect/1)

IO.puts("entries from Berlin after deleting entry with id 2")
BuddyServer.delete_entry(2)
Enum.each(BuddyServer.entries("Berlin"), &IO.inspect/1)

IO.puts("entries from Palermo after updating entry with id 3")
BuddyServer.update_entry(3, fn e -> Map.put(e, :name, "Don Corleone") end)
Enum.each(BuddyServer.entries("Palermo"), &IO.inspect/1)
