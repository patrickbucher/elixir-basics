defmodule Fraction do
  defstruct dividend: 0, divisor: 1

  def add(this, that) do
    %Fraction{
      dividend: this.dividend * that.divisor + that.dividend * this.divisor,
      divisor: this.divisor * that.divisor
    }
  end

  def subtract(this, that) do
    %Fraction{
      dividend: this.dividend * that.divisor - that.dividend * this.divisor,
      divisor: this.divisor * that.divisor
    }
  end

  def multiply(this, that) do
    %Fraction{
      dividend: this.dividend * that.dividend,
      divisor: this.divisor * that.divisor
    }
  end

  def divide(this, that) do
    %Fraction{
      dividend: this.dividend * that.divisor,
      divisor: this.divisor * that.dividend
    }
  end

  def cancel(fraction) do
    gcd = greatest_common_divisor(fraction.dividend, fraction.divisor)
    %Fraction{dividend: div(fraction.dividend, gcd), divisor: div(fraction.divisor, gcd)}
  end

  def greatest_common_divisor(a, b) when a > 0 and b > 0 do
    cond do
      a > b -> greatest_common_divisor(a - b, b)
      a < b -> greatest_common_divisor(a, b - a)
      a == b -> a
    end
  end
end
