defmodule ErrorHandling do
  def execute(f) do
    try do
      f.()
    catch
      type, value -> %{type: type, value: value}
    end
  end
end
