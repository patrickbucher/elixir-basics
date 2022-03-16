defmodule ErrorLayers do
  def execute(f) do
    try do
      try do
        f.()
      catch
        :error, err -> {:failed, :with_error}
      end
    catch
      :throw, err -> {:failed, :with_throw}
    end
  end
end
