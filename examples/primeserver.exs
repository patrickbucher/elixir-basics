defmodule PrimeServer do
  def start() do
    spawn(&loop/0)
  end

  def run_async(pid, number) do
    send(pid, {:prime, number, self()})
  end

  def get_result() do
    receive do
      {:result, number, prime} -> {number, prime}
    after
      5000 -> {:error, :timeout}
    end
  end

  defp prime?(number) when is_number(number) and number == 1, do: true
  defp prime?(number) when is_number(number) and number == 2, do: true

  defp prime?(number) when is_number(number) and number >= 2 do
    2..(number - 1)
    |> Enum.any?(fn x -> rem(number, x) == 0 end)
    |> Kernel.not()
  end

  defp loop() do
    receive do
      {:prime, number, pid} -> send(pid, {:result, number, prime?(number)})
    end

    loop()
  end
end

n_servers = 1000
n_numbers = 100_000

pool = Enum.map(1..n_servers, fn _ -> PrimeServer.start() end)

1..n_numbers
|> Enum.each(fn number ->
  server_pid = Enum.at(pool, :rand.uniform(n_servers) - 1)
  PrimeServer.run_async(server_pid, number)
end)

1..n_numbers
|> Enum.map(fn _ -> PrimeServer.get_result() end)
|> Enum.each(fn result ->
  case result do
    {number, prime} -> IO.puts("Is #{number} prime? #{prime}")
    {:error, :timeout} -> IO.puts("timeout")
  end
end)
