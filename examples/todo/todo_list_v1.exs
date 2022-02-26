defmodule TodoList do
  def new(), do: %{}

  def add_entry(todo_list, date, title) do
    Map.update(
      todo_list,
      date,
      [title],
      fn titles -> [title | titles] end
    )
  end

  def entries(todo_list, date) do
    Map.get(todo_list, date, [])
  end
end

todo_list =
  TodoList.new()
  |> TodoList.add_entry(~D[2022-02-26], "Study Elixir")
  |> TodoList.add_entry(~D[2022-02-26], "Cleaning Up")
  |> TodoList.add_entry(~D[2022-02-27], "Update Software")

TodoList.entries(todo_list, ~D[2022-02-26])
|> Enum.each(&IO.puts/1)
