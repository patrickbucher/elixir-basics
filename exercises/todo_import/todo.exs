defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    Enum.reduce(entries, %TodoList{}, fn entry, acc -> add_entry(acc, entry) end)
  end

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

  defmodule CsvImporter do
    def import(csv_file) do
      File.stream!(csv_file)
      |> Stream.map(fn line -> String.replace(line, "\n", "") end)
      |> Stream.map(fn line -> String.split(line, ",") end)
      |> Stream.map(fn [date | [title]] -> %{date: String.split(date, "/"), title: title} end)
      |> Stream.map(fn e -> %{e | date: Enum.map(e.date, &String.to_integer/1)} end)
      |> Stream.map(fn e ->
        %{
          e
          | date:
              case Date.new(Enum.at(e.date, 0), Enum.at(e.date, 1), Enum.at(e.date, 2)) do
                {:ok, date} -> date
              end
        }
      end)
      |> TodoList.new()
    end
  end
end

todo_list = TodoList.CsvImporter.import("todos.csv")

Enum.each(todo_list.entries, &IO.inspect/1)

todo_list =
  todo_list
  |> TodoList.delete_entry(2)
  |> TodoList.update_entry(3, fn e -> Map.put(e, :title, "Relaxing") end)

Enum.each(todo_list.entries, &IO.inspect/1)
