defmodule TodoList do
  def new(), do: MultiDict.new()

  def add_entry(todo_list, date, title) do
    MultiDict.add(todo_list, date, title)
  end

  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
  end
end

todo_list =
  TodoList.new()
  |> TodoList.add_entry(~D[2022-02-26], "Study Elixir")
  |> TodoList.add_entry(~D[2022-02-26], "Cleaning Up")
  |> TodoList.add_entry(~D[2022-02-27], "Update Software")

TodoList.entries(todo_list, ~D[2022-02-26])
|> Enum.each(&IO.puts/1)
