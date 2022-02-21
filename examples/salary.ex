defmodule Salary do
  def pay_out(employee, salary, opts \\ []) do
    bonus = Keyword.get(opts, :bonus, 0)
    taxes = Keyword.get(opts, :taxes, 0)
    gross = salary + bonus
    net = gross - gross * taxes
    IO.puts("#{employee} earns $#{net}")
  end
end
