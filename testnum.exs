test_num = fn
  x when is_number(x) and x > 0 ->
    :positive

  x when is_number(x) and x < 0 ->
    :negative

  x when is_number(0) and x == 0 ->
    :zero
end

IO.puts(test_num.(13))
IO.puts(test_num.(-6))
IO.puts(test_num.(0))
