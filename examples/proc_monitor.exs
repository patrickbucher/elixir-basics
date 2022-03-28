proc_finishing =
  spawn(fn ->
    Process.sleep(1000)
    IO.puts("process 1 finishing")
  end)

proc_failing =
  spawn(fn ->
    raise("process 2 failing")
  end)

Process.monitor(proc_finishing)
Process.monitor(proc_failing)

receive do
  msg -> IO.inspect(msg)
end

receive do
  msg -> IO.inspect(msg)
end
