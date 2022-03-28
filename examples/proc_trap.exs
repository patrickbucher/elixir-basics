spawn(fn ->
  Process.flag(:trap_exit, true)

  spawn_link(fn ->
    raise("Something went wrong")
  end)

  receive do
    msg -> IO.inspect(msg)
  end
end)
