defmodule FractionTest do
  use ExUnit.Case
  doctest Fraction

  test "add" do
    a = %Fraction{dividend: 2, divisor: 3}
    b = %Fraction{dividend: 1, divisor: 4}
    expected = %Fraction{dividend: 11, divisor: 12}
    assert Fraction.add(a, b) == expected
  end

  test "subtract" do
    a = %Fraction{dividend: 2, divisor: 3}
    b = %Fraction{dividend: 1, divisor: 4}
    expected = %Fraction{dividend: 5, divisor: 12}
    assert Fraction.subtract(a, b) == expected
  end

  test "multiply" do
    a = %Fraction{dividend: 2, divisor: 3}
    b = %Fraction{dividend: 1, divisor: 4}
    expected = %Fraction{dividend: 2, divisor: 12}
    assert Fraction.multiply(a, b) == expected
  end

  test "divide" do
    a = %Fraction{dividend: 2, divisor: 3}
    b = %Fraction{dividend: 1, divisor: 4}
    expected = %Fraction{dividend: 8, divisor: 3}
    assert Fraction.divide(a, b) == expected
  end

  test "cancel" do
    fraction = %Fraction{dividend: 36, divisor: 81}
    expected = %Fraction{dividend: 4, divisor: 9}
    assert Fraction.cancel(fraction) == expected
  end

  test "gcd" do
    assert Fraction.greatest_common_divisor(81, 36) == 9
  end
end
