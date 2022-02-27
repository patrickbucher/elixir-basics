defmodule TodoList do
  def new(), do: MultiDict.new()

  def add_entry(todo_list, entry) do
    MultiDict.add(todo_list, entry.date, entry)
  end

  def entries(todo_list, date) do
    MultiDict.get(todo_list, date)
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
