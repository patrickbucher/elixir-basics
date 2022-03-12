defmodule Todo.DatabaseWorker do
  defstruct db_folder: ""
  use GenServer

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  def store(pid, key, data) do
    GenServer.cast(pid, {:store, key, data})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def init(db_folder) do
    {:ok, %Todo.DatabaseWorker{db_folder: db_folder}}
  end

  def handle_cast({:store, key, data}, state) do
    IO.puts(":store")
    IO.inspect(self())

    db_folder = state.db_folder
    File.write!(file_name(db_folder, key), :erlang.term_to_binary(data))

    {:noreply, state}
  end

  def handle_call({:get, key}, _, state) do
    IO.puts(":get")
    IO.inspect(self())

    path = file_name(state.db_folder, key)

    data =
      case File.read(path) do
        {:ok, contents} -> :erlang.binary_to_term(contents)
        _ -> nil
      end

    {:reply, data, state}
  end

  defp file_name(db_folder, key) do
    Path.join(db_folder, to_string(key))
  end
end
