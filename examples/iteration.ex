defmodule Iteration do
  def each([head], func) do
    func.(head)
  end

  def each([head | tail], func) do
    func.(head)
    each(tail, func)
  end
end
