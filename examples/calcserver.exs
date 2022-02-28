defmodule CalcServer do
  def start() do
    spawn(&loop/0)
  end

  def calc(pid, task, res_pid) do
    {op, a, b} = task
    send(pid, {op, res_pid, a, b})
  end

  defp loop() do
    receive do
      {:add, pid, a, b} -> send(pid, {:result, a + b})
      {:sub, pid, a, b} -> send(pid, {:result, a - b})
    end

    loop()
  end
end

defmodule PrintServer do
  def start() do
    spawn(&loop/0)
  end

  defp loop() do
    receive do
      {:result, x} -> IO.puts(x)
    end

    loop()
  end
end

calculator = CalcServer.start()
printer = PrintServer.start()

calculations =
  [{:add, 17, 5}, {:add, -5, 8}, {:sub, 21, 3}, {:sub, 35, 50}]
  |> Enum.each(fn calculation ->
    CalcServer.calc(calculator, calculation, printer)
  end)

Process.sleep(2000)
