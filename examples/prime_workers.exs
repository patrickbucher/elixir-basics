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
    end
  end
end

defmodule PrimeServer do
  def start(n, n_workers, client) do
    workers =
      for i <- 0..(n_workers - 1),
          into: %{},
          do: {i, PrimeWorker.start()}

    spawn(fn ->
      Enum.each(2..n, fn x ->
        i_worker = rem(x, n_workers)
        worker = Map.get(workers, i_worker)
        send(worker, {:is_prime, x, self()})
      end)

      loop(%{}, 0, n - 1, client)
    end)
  end

  defp loop(results, got, needed, client) do
    receive do
      {:prime_result, x, result} ->
        results = Map.put(results, x, result)
        got = got + 1

        if got == needed do
          send(client, {:results, results})
        else
          loop(results, got, needed, client)
        end
    end
  end
end

args = System.argv()
[n, procs | _] = args
{n, ""} = Integer.parse(n, 10)
{procs, ""} = Integer.parse(procs, 10)

PrimeServer.start(n, procs, self())

receive do
  {:results, results} ->
    n_primes =
      results
      |> Stream.filter(fn {_, prime} -> prime end)
      |> Enum.count()

    IO.puts("Found #{n_primes} prime numbers from 2 to #{n}.")
end
