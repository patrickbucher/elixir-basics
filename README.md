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
- [Mix (Build Tool)](https://hexdocs.pm/mix/Mix.html)

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

# Functions

Functions must always be part of a module. The same naming rules as for
variables apply, whereas `?` indicates a predicate function (that returns `true`
or `false`), and `!` that a function may cause a runtime error.

Small functions can be written on a single line:

```elixir
defmodule Geometry do
  def rectangle_area(a, b), do: a * b
  def rectangle_perimeter(a, b), do: 2 * a + 2 * b
end
```

Notice the `,` after the parameter list, the `:` after `do`, and the missing
`end` indicator after the function.

## Function Composition

The module `SwissGrading` computes rounded grades from a number of points
achieved and the maximum points achievable (`swiss_grading.ex`):

```elixir
defmodule SwissGrading do
  def grade(points, max) do
    points_ratio = ratio(points, max)
    exact_grade = add(multiply(points_ratio, 5), 1)
    final_grade = round(exact_grade, 0.1)
    final_grade
  end
  defp ratio(x, y) do
    x / y
  end
  defp multiply(x, y) do
    x * y
  end
  defp add(x, y) do
    x + y
  end
  defp round(x, precision) do
    round(x * 1/precision) * precision
  end
end
```

Functions defined using `defp` are private to the module, i.e. not exported.

Two mechanisms for function composition are used in the `grade()` function:

1. The return value of a function is carried over in a variable (`points_ratio`,
   `exact_grade`).
2. The function calls are nested (`add(multiply(points_ratio, 5), 1)`).

The pipeline operator `|>` offers a more succinct notation for this purpose:

```elixir
def grade(points, max) do
  points |> ratio(max) |> multiply(5) |> add(1) |> round(0.1)
end
```

For each use of the pipeline, the value of the expression from the left is taken
and used as the first argument for the function call on the right.

Longer pipelines are usually spread out over multiple lines:

```elixir
def grade(points, max) do
  points
  |> ratio(max)
  |> multiply(5)
  |> add(1)
  |> round(0.1)
end
```

## Arities and Default Values

The number of arguments a function expects is called the function's _arity_.
This number is referred to in the documentation, e.g. `SwissGrading.grade/2`
denoting that the `grade()` function of the `SwissGrading` module expects `2`
arguments.

Lower-arity functions often use higher-arity functions to perform their work, as
`inc/1` does using `inc/2` (`Increment.ex`):

```elixir
defmodule Increment do
  def inc(a, x) do
    a + x
  end
  def inc(a) do
    inc(a, 1)
  end
end
```

The two function definitions can be merged by using a default value for the `x`
argument using the `\\` operator:

```elixir
defmodule Increment do
  def inc(a, x \\ 1) do
    a + x
  end
end
```

## Imports and Aliases

Other modules can be imported into the current module, so that function calls
don't have to be qualified using their module name. It's also possible to use an
alias name for an imported module (`hello_calculator.ex`):

```elixir
defmodule Geometry do
  def rectangle_area(a, b) do
    a * b
  end
  def rectangle_perimeter(a, b) do
    2 * a + 2 * b
  end
end

defmodule HelloCalculator do
  import IO
  alias Geometry, as: Geom
  def rect_info(a, b) do
    area = Geom.rectangle_area(a, b)
    perimeter = Geom.rectangle_perimeter(a, b)
    puts("Rectangle(#{a}, #{b}): Area #{area}, Perimeter: #{perimeter}")
  end
end
```

The module `HelloCalculator` imports `IO`, so `puts` can be used without further
qualification (instead of `IO.puts`). `Geometry` is also imported, but using an
alias, so that it can be used as `Geom`:

    $ iex hello_calculator.ex
    > HelloCalculator.rect_info(3, 5)
    Rectangle(3, 5): Area 15, Perimeter: 16
    :ok

The [Kernel](https://hexdocs.pm/elixir/Kernel.html) module is always imported
automatically, so that its functions can be used without further qualification.
