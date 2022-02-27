defmodule TodoList do
  def new(), do: MultiDict.new()

  def add_entry(todo_list, entry) do
    MultiDict.add(todo_list, entry.date, entry)
  end

  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
  end
end

todo_list =
  TodoList.new()
  |> TodoList.add_entry(%{date: ~D[2022-02-26], title: "Study Elixir"})
  |> TodoList.add_entry(%{date: ~D[2022-02-26], title: "Cleaning Up"})
  |> TodoList.add_entry(%{date: ~D[2022-02-27], title: "Update Software"})

TodoList.entries(todo_list, ~D[2022-02-26])
|> Enum.each(&IO.inspect/1)
