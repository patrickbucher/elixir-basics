defmodule Todo.Database do
  defstruct workers: %{}
  use GenServer

  @db_folder "./persist"
  @n_workers 3

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(key) do
    GenServer.call(__MODULE__, {:get, key})
  end

  def init(_) do
    File.mkdir_p!(@db_folder)

    workers =
      for i <- 0..(@n_workers - 1),
          into: %{},
          do: {i, (fn {:ok, worker} -> worker end).(Todo.DatabaseWorker.start(@db_folder))}

    {:ok, %Todo.Database{workers: workers}}
  end

  def handle_cast({:store, key, data}, state) do
    worker = get_worker(state, key)
    Todo.DatabaseWorker.store(worker, key, data)
    {:noreply, state}
  end

  def handle_call({:get, key}, _, state) do
    worker = get_worker(state, key)
    data = Todo.DatabaseWorker.get(worker, key)
    {:reply, data, state}
  end

  defp get_worker(state, key) do
    workers = Map.get(state, :workers)
    index = :erlang.phash2(key, @n_workers)
    Map.get(workers, index)
  end
end
