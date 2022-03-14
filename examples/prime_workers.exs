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

defmodule PrimeWorker do
  def start() do
    spawn(fn -> loop() end)
  end

  defp loop() do
    receive do
      {:is_prime, x, pid} ->
        send(pid, {:prime_result, x, PrimeNumbers.is_prime(x)})
        loop()

      {:terminate, pid} ->
        send(pid, {:done})
    end
  end
end

defmodule PrimeClient do
  def start() do
    spawn(fn -> loop(0) end)
  end

  def loop(found) do
    receive do
      {:prime_result, _, prime} ->
        if prime do
          loop(found + 1)
        else
          loop(found)
        end

      {:query_primes, pid} ->
        send(pid, {:primes_found, found})
    end

    loop(found)
  end
end

args = System.argv()
[n, n_workers | _] = args
{n, ""} = Integer.parse(n, 10)
{n_workers, ""} = Integer.parse(n_workers, 10)

client = PrimeClient.start()

workers =
  for i <- 0..(n_workers - 1),
      into: %{},
      do: {i, PrimeWorker.start()}

Enum.each(2..n, fn x ->
  i_worker = rem(x, n_workers)
  worker = Map.get(workers, i_worker)
  send(worker, {:is_prime, x, client})
end)

workers
|> Enum.each(fn {_, w} ->
  send(w, {:terminate, self()})

  receive do
    {:done} -> {:nothing}
  end
end)

send(client, {:query_primes, self()})

receive do
  {:primes_found, found} ->
    IO.puts("Found #{found} primes from 2 to #{n}.")
end
