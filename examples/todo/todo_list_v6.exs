defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(), do: %TodoList{}

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
    %TodoList{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      {:ok, old_entry} ->
        new_entry = %{id: ^entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, entry_id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    new_entries = Map.filter(todo_list.entries, fn {_, e} -> e.id != entry_id end)
    %TodoList{todo_list | entries: new_entries}
  end
end

defmodule TodoServer do
  def start() do
    spawn(fn -> loop(TodoList.new()) end)
  end

  def add_entry(pid, entry) do
    send(pid, {:add, entry})
  end

  def update_entry(pid, entry_id, updater_fun) do
    send(pid, {:upd, entry_id, updater_fun})
  end

  def delete_entry(pid, entry_id) do
    send(pid, {:del, entry_id})
  end

  def entries(pid, date) do
    send(pid, {:entries, date, self()})

    receive do
      {:ok, entries} -> entries
    end
  end

  defp loop(todo_list) do
    new_todo =
      receive do
        {:add, entry} ->
          TodoList.add_entry(todo_list, entry)

        {:upd, entry_id, updater_fun} ->
          TodoList.update_entry(todo_list, entry_id, updater_fun)

        {:del, entry_id} ->
          TodoList.delete_entry(todo_list, entry_id)

        {:entries, date, pid} ->
          send(pid, {:ok, TodoList.entries(todo_list, date)})
          todo_list
      end

    loop(new_todo)
  end
end

pid = TodoServer.start()

IO.puts("adding some entries")
TodoServer.add_entry(pid, %{date: ~D[2022-02-26], title: "Study Elixir"})
TodoServer.add_entry(pid, %{date: ~D[2022-02-26], title: "Cleaning Up"})
TodoServer.add_entry(pid, %{date: ~D[2022-02-27], title: "Update Software"})

IO.puts("entries from 2022-02-26")
Enum.each(TodoServer.entries(pid, ~D[2022-02-26]), &IO.inspect/1)

IO.puts("entries from 2022-02-26 after deleting entry with id 2")
TodoServer.delete_entry(pid, 2)
Enum.each(TodoServer.entries(pid, ~D[2022-02-26]), &IO.inspect/1)

IO.puts("entries from 2022-02-27 after updating entry with id 3")
TodoServer.update_entry(pid, 3, fn e -> Map.put(e, :title, "Relaxing") end)
Enum.each(TodoServer.entries(pid, ~D[2022-02-27]), &IO.inspect/1)
