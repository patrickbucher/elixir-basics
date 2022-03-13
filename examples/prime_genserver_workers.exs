defmodule PrimeNumbers do
  def is_prime(x) when is_number(x) and x == 2, do: true

  def is_prime(x) when is_number(x) and x > 2 do
    from = 2
    to = trunc(:math.sqrt(x))
    n_total = to - from + 1

    n_tried =
      Enum.take_while(from..to, fn i -> rem(x, i) != 0 end)
      |> Enum.count()

    n_total == n_tried
  end

  def is_prime(x) when is_number(x), do: false
end

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

  def handle_call({:is_prime, x}, _, state) do
    i_worker = rem(x, state.n_workers)
    worker = Map.get(state.workers, i_worker)
    {:reply, PrimeWorker.is_prime(worker, x), state}
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

defmodule PrimeWorker do
  defstruct number: -1, handled: 0
  use GenServer

  @debug false

  def start(number) do
    GenServer.start(__MODULE__, number)
  end

  def is_prime(pid, x) do
    GenServer.call(pid, {:is_prime, x})
  end

  def stats(pid) do
    GenServer.call(pid, {:stats})
  end

  def init(number) do
    if @debug, do: IO.puts("spawned worker #{number}")
    {:ok, %PrimeWorker{number: number, handled: 0}}
  end

  def handle_call({:is_prime, x}, _, state) do
    result = PrimeNumbers.is_prime(x)

    if @debug and result, do: IO.puts("worker #{state} found prime number #{x}")

    {:reply, result, %PrimeWorker{state | handled: state.handled + 1}}
  end

  def handle_call({:stats}, _, state) do
    {:reply, state.handled, state}
  end
end

{:ok, pid} = PrimeServer.start(7)

1..100_000_000
|> Enum.filter(fn i -> PrimeServer.is_prime(pid, i) end)
|> Enum.each(fn i -> IO.puts("#{i} is a prime number.") end)

PrimeServer.worker_stats(pid)
|> Enum.each(fn {k, v} -> IO.puts("Worker #{k} handled #{v} jobs.") end)
