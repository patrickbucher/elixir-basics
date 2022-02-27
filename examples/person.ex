defmodule Person do
  defstruct name: "", age: 0

  def new(name, age) do
    %Person{name: name, age: age}
  end
end

defimpl String.Chars, for: Person do
  def to_string(thing) do
    "#{thing.name} (age: #{thing.age})"
  end
end
