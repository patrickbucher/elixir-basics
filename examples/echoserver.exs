defmodule Echo do
  def loop() do
    receive do
      {:message, payload} -> IO.puts(payload)
      {:important_message, payload} -> IO.puts(String.upcase(payload))
      unknown -> IO.puts(:stderr, "unsupported message format")
    end

    loop()
  end
end

printer = spawn(&Echo.loop/0)

send(printer, {:message, "Hello"})
send(printer, {:message, "World"})
send(printer, {:important_message, "and beyond"})
send(printer, {:unknown, "Universe"})
send(printer, {:message, "Goodbye"})

Process.sleep(1000)
