defmodule ErrorHandling do
  def execute(f) do
    try do
      f.()
      IO.puts("ok")
    catch
      type, value ->
        IO.puts("Error: #{inspect(type)} #{inspect(value)}")
    end
  end
end
