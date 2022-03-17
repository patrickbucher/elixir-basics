defmodule ErrorAfter do
  def execute(f) do
    try do
      f.()
    catch
      type, value -> IO.puts("error: #{type} (#{value})")
    after
      IO.puts("done, cleaning up…")
    end
  end
end
