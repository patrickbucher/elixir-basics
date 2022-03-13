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
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def is_prime(pid, x) do
    GenServer.call(pid, {:is_prime, x})
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:is_prime, x}, _, state) do
    {:reply, PrimeNumbers.is_prime(x), state}
  end
end

{:ok, pid} = PrimeServer.start()

1..100
|> Stream.filter(fn i -> PrimeServer.is_prime(pid, i) end)
|> Enum.each(fn i -> IO.puts("#{i} is a prime number.") end)
