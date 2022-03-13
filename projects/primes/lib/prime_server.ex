defmodule PrimeServer do
  defstruct n_workers: 0, workers: %{}
  use GenServer

  def start(n_workers) when is_number(n_workers) and n_workers > 0 do
    GenServer.start(__MODULE__, n_workers)
  end

  def is_prime(pid, x) do
    GenServer.call(pid, {:is_prime, x})
  end

  def worker_stats(pid) do
    GenServer.call(pid, {:worker_stats})
  end

  def init(n_workers) do
    workers =
      for i <- 0..(n_workers - 1),
          into: %{},
          do: {i, (fn {:ok, worker} -> worker end).(PrimeWorker.start(i))}

    {:ok, %PrimeServer{n_workers: n_workers, workers: workers}}
  end

  def handle_call({:is_prime, x}, caller, state) do
    spawn(fn ->
      i_worker = rem(x, state.n_workers)
      worker = Map.get(state.workers, i_worker)
      GenServer.reply(caller, PrimeWorker.is_prime(worker, x))
    end)

    {:noreply, state}
  end

  def handle_call({:worker_stats}, _, state) do
    stats =
      state.workers
      |> Enum.map(fn {i, pid} ->
        stats = PrimeWorker.stats(pid)
        {i, stats}
      end)

    {:reply, stats, state}
  end
end
