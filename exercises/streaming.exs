defmodule Streaming do
  def lines_lengths!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.length(&1))
  end

  def longest_line_length!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(&String.length(&1))
    |> Enum.max()
  end

  def longest_line!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(fn line -> {line, String.length(line)} end)
    |> Enum.max_by(fn x -> elem(x, 1) end)
    |> elem(0)
  end

  def words_per_line!(path) do
    File.stream!(path)
    |> Stream.map(fn line -> length(String.split(line)) end)
  end
end

path = "./streaming.exs"

IO.puts("lines_lengths!")
Streaming.lines_lengths!(path) |> Enum.each(&IO.puts/1)

IO.puts("longest_line_length!")
Streaming.longest_line_length!(path) |> IO.puts()

IO.puts("longest_line!")
Streaming.longest_line!(path) |> IO.puts()

IO.puts("words_per_line!")
Streaming.words_per_line!(path) |> Enum.each(&IO.puts/1)
