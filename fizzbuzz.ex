defmodule FizzBuzz do
  defmodule UnlessIfElse do
    def fizzbuzz(min, max) when min <= max do
      Enum.each(min..max, &fizzbuzz/1)
    end

    defp fizzbuzz(x) do
      unless rem(x, 3) == 0 or rem(x, 5) == 0 do
        IO.puts(x)
      end

      if rem(x, 15) == 0 do
        IO.puts("FizzBuzz")
      else
        if rem(x, 3) == 0 do
          IO.puts("Fizz")
        else
          if rem(x, 5) == 0 do
            IO.puts("Buzz")
          end
        end
      end
    end
  end

  defmodule Multiclause do
    def fizzbuzz(min, max) when min <= max do
      Enum.each(min..max, &fizzbuzz/1)
    end

    defp fizzbuzz(x) when rem(x, 15) == 0, do: IO.puts("FizzBuzz")
    defp fizzbuzz(x) when rem(x, 3) == 0, do: IO.puts("Fizz")
    defp fizzbuzz(x) when rem(x, 5) == 0, do: IO.puts("Buzz")
    defp fizzbuzz(x), do: IO.puts(x)
  end

  defmodule Cond do
    def fizzbuzz(min, max) when min <= max do
      Enum.each(min..max, &fizzbuzz/1)
    end

    defp fizzbuzz(x) do
      cond do
        rem(x, 15) == 0 -> IO.puts("FizzBuzz")
        rem(x, 3) == 0 -> IO.puts("Fizz")
        rem(x, 5) == 0 -> IO.puts("Buzz")
        true -> IO.puts(x)
      end
    end
  end

  defmodule Case do
    def fizzbuzz(min, max) when min <= max do
      Enum.each(min..max, &fizzbuzz/1)
    end

    defp fizzbuzz(x) do
      case {rem(x, 3), rem(x, 5)} do
        {0, 0} -> IO.puts("FizzBuzz")
        {0, _} -> IO.puts("Fizz")
        {_, 0} -> IO.puts("Buzz")
        {_, _} -> IO.puts(x)
      end
    end
  end
end
