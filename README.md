These notes are based on [Elixir in
Action](https://www.manning.com/books/elixir-in-action-second-edition) by Saša
Jurić.

# Setup

Install Elixir (on Arch Linux):

    # pacman -S elixir

The following binaries are now available:

- `elixir(1)`: The Elixir script runner
- `elixirc(1)`: The Elixir compiler
- `iex(1)`: The Elixir shell

Check the installed version:

    $ elixir --version

Run Elixir interactively:

    $ iex
    iex(1)> IO.puts("Hello, World!")
    Hello, World!
    :ok

Write an Elixir script (`hello.exs`, the `s` stands for "script"):

```elixir
IO.puts("Hello, World!")
```

Run the Elixir script:

    $ elixir hello.exs
    Hello, World!

## Documentation

- [Install Elixir](https://elixir-lang.org/install.html)
- [Introduction](https://elixir-lang.org/getting-started/introduction.html)
- [Reference](https://hexdocs.pm/elixir/)
- [Erlang Documentation](https://www.erlang.org/doc/)
- [Elixir/Erlang Crash Course](https://elixir-lang.org/crash-course.html)
- [IEx](https://hexdocs.pm/iex/IEx.html)

For interactive help, launch `iex` and type `h`:

    $ iex
    iex(1)> h

For help on a specific topic, launch `iex` and type `h [topic]`:

    $ iex
    iex(1)> h Kernel

# Variables

Variables are dynamically typed. Variable assignments (_bindings_) are
expressions; they return the value being assigned:

    > a = 3
    3
    > b = 1.5
    1.5
    > c = a + b
    4.5

Variable names must start with a lowercase alphabetic character or an
underscore. By convention, only lowercase characters, numbers, and underscores
are used; the last character can also be a question (`?`) or exclamation mark
(`!`):

- `good_variable_name`
- `good_variable_name_2`
- `good_variable_name?`
- `good_variable_name!`
- `validButNotGoodVariableName`
- `InvalidVariableName`

Variables cannot be _changed_, but _rebound_:

    > a = 3
    3
    > a = 4
    4

# Modules

Functions are grouped together in Modules (`geometry.ex`):

```elixir
defmodule Geometry do
  def rectangle_area(a, b) do
    a * b
  end
  def rectangle_perimeter(a, b) do
    2 * a + 2 * b
  end
end
```

Modules can be used interactively using `iex`:

    $ iex
    > Geometry.rectangle_area(3, 2)
    6
    > Geometry.rectangle_perimeter(3, 2)
    10

Module names are written in CamelCase; alphanumeric characters and the dot are
allowed in them.

Multiple modules can be defined in the same file. Modules can also be nested
hierarchically (`calculator.ex`):

```elixir
defmodule Calculator do
  defmodule Basic do
    def add(a, b) do
      a + b
    end
  end
  defmodule Advanced do
    def pow(a, b) do
      Integer.pow(a, b)
    end
  end
end
```

The module names are qualified with a dot:

    $ iex calculator.ex
    > Calculator.Basic.add(5, 3)
    8
    > Calculator.Advanced.pow(5, 2)
    25
