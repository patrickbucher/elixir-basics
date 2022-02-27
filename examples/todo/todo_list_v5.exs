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

  defmodule Entry do
    defstruct date: nil, title: nil

    def new(date, title) do
      %Entry{date: date, title: title}
    end
  end
end

todo_list =
  TodoList.new()
  |> TodoList.add_entry(TodoList.Entry.new(~D[2022-02-26], "Study Elixir"))
  |> TodoList.add_entry(TodoList.Entry.new(~D[2022-02-26], "Cleaning Up"))
  |> TodoList.add_entry(TodoList.Entry.new(~D[2022-02-27], "Update Software"))

TodoList.entries(todo_list, ~D[2022-02-26])
|> Enum.each(&IO.inspect/1)
