defmodule Buddies do
  defstruct auto_id: 1, entries: %{}

  def new() do
    %Buddies{}
  end

  def add_entry(buddies, entry) do
    entry = Map.put(entry, :id, buddies.auto_id)
    new_entries = Map.put(buddies.entries, buddies.auto_id, entry)
    %Buddies{buddies | entries: new_entries, auto_id: buddies.auto_id + 1}
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

  def entries(buddies, city) do
    buddies.entries
    |> Stream.filter(fn {_, entry} -> entry.city == city end)
    |> Enum.map(fn {_, entry} -> entry end)
  end
end

defmodule BuddyServer do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add, entry})
  end

  def update_entry(pid, entry_id, updater_fun) do
    GenServer.cast(pid, {:upd, entry_id, updater_fun})
  end

  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:del, entry_id})
  end

  def entries(pid, city) do
    GenServer.call(pid, {:get, city})
  end

  def init(_) do
    {:ok, Buddies.new()}
  end

  def handle_cast({:add, entry}, state) do
    {:noreply, Buddies.add_entry(state, entry)}
  end

  def handle_cast({:upd, entry_id, updater_fun}, state) do
    {:noreply, Buddies.update_entry(state, entry_id, updater_fun)}
  end

  def handle_cast({:del, entry_id}, state) do
    {:noreply, Buddies.delete_entry(state, entry_id)}
  end

  def handle_call({:get, city}, _, state) do
    {:reply, Buddies.entries(state, city), state}
  end
end

{:ok, pid} = BuddyServer.start()

IO.puts("adding some buddies")
BuddyServer.add_entry(pid, %{city: "Berlin", name: "Hans"})
BuddyServer.add_entry(pid, %{city: "Berlin", name: "Hermann"})
BuddyServer.add_entry(pid, %{city: "Palermo", name: "Vito"})

IO.puts("entries from Berlin")
Enum.each(BuddyServer.entries(pid, "Berlin"), &IO.inspect/1)

IO.puts("entries from Berlin after deleting entry with id 2")
BuddyServer.delete_entry(pid, 2)
Enum.each(BuddyServer.entries(pid, "Berlin"), &IO.inspect/1)

IO.puts("entries from Palermo after updating entry with id 3")
BuddyServer.update_entry(pid, 3, fn e -> Map.put(e, :name, "Don Corleone") end)
Enum.each(BuddyServer.entries(pid, "Palermo"), &IO.inspect/1)
