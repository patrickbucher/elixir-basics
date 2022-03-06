defmodule Buddies do
  defstruct auto_id: 1, entries: %{}
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
    {:ok, %Buddies{}}
  end

  def handle_cast({:add, entry}, state) do
    entry = Map.put(entry, :id, state.auto_id)
    new_entries = Map.put(state.entries, state.auto_id, entry)

    new_buddies = %Buddies{
      state
      | entries: new_entries,
        auto_id: state.auto_id + 1
    }

    {:noreply, new_buddies}
  end

  def handle_cast({:upd, entry_id, updater_fun}, state) do
    case Map.fetch(state.entries, entry_id) do
      :error ->
        {:noreply, state}

      {:ok, old_entry} ->
        new_entry = %{id: ^entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(state.entries, entry_id, new_entry)
        {:noreply, %Buddies{state | entries: new_entries}}
    end
  end

  def handle_cast({:del, entry_id}, state) do
    new_entries = Map.filter(state.entries, fn {_, e} -> e.id != entry_id end)
    {:noreply, %Buddies{state | entries: new_entries}}
  end

  def handle_call({:get, city}, _, state) do
    found_entries =
      state.entries
      |> Stream.filter(fn {_, entry} -> entry.city == city end)
      |> Enum.map(fn {_, entry} -> entry end)

    {:reply, found_entries, state}
  end
end

{:ok, pid} = Buddies.start()

IO.puts("adding some buddies")
Buddies.add_entry(pid, %{city: "Berlin", name: "Hans"})
Buddies.add_entry(pid, %{city: "Berlin", name: "Hermann"})
Buddies.add_entry(pid, %{city: "Palermo", name: "Vito"})

IO.puts("entries from Berlin")
Enum.each(Buddies.entries(pid, "Berlin"), &IO.inspect/1)

IO.puts("entries from Berlin after deleting entry with id 2")
Buddies.delete_entry(pid, 2)
Enum.each(Buddies.entries(pid, "Berlin"), &IO.inspect/1)

IO.puts("entries from Palermo after updating entry with id 3")
Buddies.update_entry(pid, 3, fn e -> Map.put(e, :name, "Don Corleone") end)
Enum.each(Buddies.entries(pid, "Palermo"), &IO.inspect/1)
