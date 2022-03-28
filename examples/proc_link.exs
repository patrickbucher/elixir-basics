spawn(fn ->
  spawn_link(fn ->
    Process.sleep(1000)
    IO.puts("Process 2: finishing...")
  end)

  raise("Process 1: failing...")
end)
