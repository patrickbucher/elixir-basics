defmodule TodoList do
  defstruct auto_id: 1, entries: %{}
  use GenServer

  def start() do
    GenServer.start(TodoList, nil)
  end

  def entries(pid, date) do
    GenServer.call(pid, {:get, date})
  end

  def update_entry(pid, entry_id, updater_fun) do
    GenServer.cast(pid, {:upd, entry_id, updater_fun})
  end

  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:del, entry_id})
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add, entry})
  end

  def init(_) do
    {:ok, %TodoList{}}
  end

  def handle_cast({:add, entry}, state) do
    entry = Map.put(entry, :id, state.auto_id)
    new_entries = Map.put(state.entries, state.auto_id, entry)

    new_state = %TodoList{
      state
      | entries: new_entries,
        auto_id: state.auto_id + 1
    }

    {:noreply, new_state}
  end

  def handle_cast({:upd, entry_id, updater_fun}, state) do
    case Map.fetch(state.entries, entry_id) do
      :error ->
        {:noreply, state}

      {:ok, old_entry} ->
        new_entry = %{id: ^entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(state.entries, entry_id, new_entry)
        {:noreply, %TodoList{state | entries: new_entries}}
    end
  end

  def handle_cast({:del, entry_id}, state) do
    new_entries = Map.filter(state.entries, fn {_, e} -> e.id != entry_id end)
    {:noreply, %TodoList{state | entries: new_entries}}
  end

  def handle_call({:get, date}, _, state) do
    found_entries =
      state.entries
      |> Stream.filter(fn {_, entry} -> entry.date == date end)
      |> Enum.map(fn {_, entry} -> entry end)

    {:reply, found_entries, state}
  end
end

{:ok, pid} = TodoList.start()

IO.puts("adding some entries")
TodoList.add_entry(pid, %{date: ~D[2022-02-26], title: "Study Elixir"})
TodoList.add_entry(pid, %{date: ~D[2022-02-26], title: "Cleaning Up"})
TodoList.add_entry(pid, %{date: ~D[2022-02-27], title: "Update Software"})

IO.puts("entries from 2022-02-26")
Enum.each(TodoList.entries(pid, ~D[2022-02-26]), &IO.inspect/1)

IO.puts("entries from 2022-02-26 after deleting entry with id 2")
TodoList.delete_entry(pid, 2)
Enum.each(TodoList.entries(pid, ~D[2022-02-26]), &IO.inspect/1)

IO.puts("entries from 2022-02-27 after updating entry with id 3")
TodoList.update_entry(pid, 3, fn e -> Map.put(e, :title, "Relaxing") end)
Enum.each(TodoList.entries(pid, ~D[2022-02-27]), &IO.inspect/1)
