args = System.argv()
[n, procs | _] = args
{n, ""} = Integer.parse(n, 10)
{procs, ""} = Integer.parse(procs, 10)

{:ok, pid} = PrimeServer.start(procs)

1..n
|> Enum.filter(fn i -> PrimeServer.is_prime(pid, i) end)
|> Enum.each(fn i -> IO.puts("#{i} is a prime number.") end)

PrimeServer.worker_stats(pid)
|> Enum.each(fn {k, v} -> IO.puts("Worker #{k} handled #{v} jobs.") end)
