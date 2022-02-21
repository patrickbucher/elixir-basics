defmodule Calculator do
  defmodule Basic do
    def add(a, b) do
      a + b
    end
  end

  defmodule Advanced do
    def pow(a, b) do
      Integer.pow(a, b)
    end
  end
end
