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

## Module Attributes

Module attributes are used to define constants and to provide documentation
(`free_fall.ex`):

```elixir
defmodule FreeFall do
  @moduledoc "Offers functions concerning the free fall of objects"
  @gravity 9.81

  @doc "Computes the velocity on impact given the height"
  @spec impact_velocity(number) :: number
  def impact_velocity(height) do
    :math.sqrt(2 * @gravity * height)
  end

  @doc "Computes the time it takes for the object to reach the ground"
  @spec fall_time(number) :: number
  def fall_time(height) do
    impact_velocity(height) / @gravity
  end
end
```

`@gravity` defines a compile-time constant.

`@moduledoc` and `@doc` provides documentation for the surrounding module and
for the following function, respectively. `@spec` provides [type
specificatons](https://hexdocs.pm/elixir/typespecs.html) that can be analyzed
using the [`dialyzer`](https://www.erlang.org/doc/man/dialyzer.html) The module
needs to be compiled in order to have this documentation accessible during
runtime:

    $ elixirc free_fall.ex
    $ file Elixir.FreeFall.beam
    Elixir.FreeFall.beam: Erlang BEAM file
    $ iex
    > Code.fetch_docs(FreeFall)
    {:docs_v1, 2, :elixir, "text/markdown",
     %{"en" => "Offers functions concerning the free fall of objects"}, %{},
     [
       {{:function, :fall_time, 1}, 10, ["fall_time(height)"],
        %{"en" => "Computes the time it takes for the object to reach the ground"},
        %{}},
       {{:function, :impact_velocity, 1}, 5, ["impact_velocity(height)"],
        %{"en" => "Computes the velocity on impact given the height"}, %{}}
     ]}

The help function (`h`) is more helpful for interactive use:

     > h FreeFall

                                    FreeFall

    Offers functions concerning the free fall of objects

    > h FreeFall.impact_velocity

                          def impact_velocity(height)

      @spec impact_velocity(number()) :: number()

    Computes the velocity on impact given the height


The [Module](https://hexdocs.pm/elixir/Module.html) documentation contains more
information on built-in module attributes.

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
  |> multiply(5) # scaling from 0..1 to 0..5
  |> add(1)      # shifting from 0..5 to 1..6
  |> round(0.1)
end
```

Comments start with the `#` character and go to the end of the line. There's no
special syntax for multi-line comments, i.e. every line of a multi-line comment
has to start with a `#`.

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

# Data Types

## Integers

Integers don't have an upper limit:

    > 123456789 * 987654321 * 123456789 * 987654321
    14867566530049990397812181822702361

The underscore character can be used as a visual delimiter:

    > 100_000_000 * 0.753_214_978
    75321497.8

Integer division and remainder are done using the `Kernel` functions `div` and
`rem`:

    > div(25, 4)
    6
    > rem(25, 4)
    1

## Atoms

Atoms are named constants that either start with a colon or an uppercase letter:

    > :an_atom
    :an_atom
    > :"an atom with spaces"
    :"an atom with spaces"
    > AlsoAnAtom
    AlsoAnAtom

Atoms are prefixed with `Elixir` automatically:

    > AnAtom == Elixir.AnAtom
    true

Boolean values are actually atoms:

    > true == :true
    true
    > false == :false
    true

And so is `nil`:

    > nil == :nil
    true

Both `nil` and `false` are treated as _falsy_, all the other values as _truthy_,
i.e. they evaluate to `false` or `true`, respectively:

    > nil || false || 4
    4

## Tuples

Tuples group values together in a collection with a fixed size:

    > dilbert = {"Dilbert", 42, 120_000}
    {"Dilbert", 42, 120000}

Elements can be accessed using the `Kernel` function `elem/2`:

    > elem(dilbert, 0)
    "Dilbert"
    > elem(dilbert, 2)
    120000

The `put_elem/3` function doesn't modify the tuple, but returns a copy of it,
with the given element replaced:

    > older_dilbert = put_elem(dilbert, 1, 43)
    {"Dilbert", 43, 120000}

## Lists

Lists are variable-sized collections to store multiple values

    > numbers = [3, 7, 8, 2]
    [3, 7, 8, 2]

They are implemented as linked lists, therefore many operations have a runtime
complexity of O(n), as does the `length/1` function:

    > length(numbers)
    4

The `in` operator can be used to check whether or not a value is contained in a
list:

    > 7 in numbers
    true
    > 9 in numbers
    false

Both the [List](https://hexdocs.pm/elixir/List.html) and the
[Enum](https://hexdocs.pm/elixir/Enum.html) module offer functions for dealing
with lists.

A list element can be accessed by its index using the `Enum.at/2` function:

    > Enum.at(numbers, 0)
    3
    > Enum.at(numbers, 3)
    2

Like tuples, lists are immutable. Modified copies of them can be created using
functions such as `List.repalce_at/3` and `List.insert_at/3`:

    > new_numbers = List.replace_at(numbers, 0, 1)
    [1, 7, 8, 2]
    > more_numbers = List.insert_at(numbers, 2, 4)
    [3, 7, 4, 8, 2]

Use the index `-1` to append an element at the end of a list:

    > even_more_numbers = List.insert_at(more_numbers, -1, 5)
    [3, 7, 4, 8, 2, 5]

Two lists can be concatenated using the `++` operator:

    > [1, 2, 3] ++ [4, 5, 6] 
    [1, 2, 3, 4, 5, 6]

### Cons Cells

Lists are implemented as _cons cells_ (i.e. like in LISP) and support a special
head/tail syntax:

    [head | tail]

The head goes to the left side of the `|`, the tail to its right side:

    > numbers = [1 | [2, 3, 4]]
    [1, 2, 3, 4]

The `hd` (head) and `tl` (tail) function can be used to access the head (a
single value) and the tail (usually a list) of a list:

    > hd(numbers)
    1
    > tl(numbers)
    [2, 3, 4]

Lists with a tail that is not itself a list are called _improper lists_.

The head/tail syntax can be used to push elements at the front of a list with
O(1) complexity:

    > numbers_from_zero = [0 | numbers]
    [0, 1, 2, 3, 4]

## Maps

Maps are key/value stores commonly used as dynamically sized associative arrays
or as records. A map is created using the `%{}` syntax:

    > empty_map = %{}
    %{}

A map can be created with initial values defined as key/value pairs:

    > squares = %{1 => 1, 2 => 4, 3 => 9}
    %{1 => 1, 2 => 4, 3 => 9}

Using the `Map/new/1` function, a map is created based on a list of key/value
tuples:

    > doubles = Map.new([{1, 2}, {2, 4}, {3, 6}])
    %{1 => 2, 2 => 4, 3 => 6}

A value can be retrieved by indicating the key in square brackets:

    > squares[1]
    1
    > squares[2]
    4

If the key is not found in the map, `nil` is returned:

    > squares[4]
    nil

The `Map.get/3` function accepts a fallback value for this case:

    > Map.get(squares, 3, :not_found)
    9
    > Map.get(squares, 4, :not_found)
    :not_found

The `Map.fetch/2` function indicates whether or not the value was found:

    > Map.fetch(squares, 3)
    {:ok, 9}
    > Map.fetch(squares, 4)
    :error

The `Map.fetch!/2` function (notice the `!`) raises an error if the key
indicated is not contained in the given map.

Other useful functions for Maps are `Map.put/3`, `Map.delete/2`, and
`Map.update/4`, as well as others in the
[Map](https://hexdocs.pm/elixir/Map.html) module.

Since maps are enumerables, the functions of the
[Enum](https://hexdocs.pm/elixir/Enum.html) module can be used on them, too.

### Records

Maps can be used as records:

    > dilbert = %{:name => "Dilbert", :age => 42, :job => "Engineer"}
    %{age: 42, job: "Engineer", name: "Dilbert"}
    > dilbert[:name]
    "Dilbert"

If the keys are atoms, this shorter syntax can be used:

    > ashok = %{name: "Ashok", age: 25, job: "Intern"}
    %{age: 25, job: "Intern", name: "Ashok"}
    > ashok.name
    "Ashok"

Existing fields can be updated using this special syntax:

    > promoted_ashok = %{ashok | age: 26, job: "Engineer"}
    %{age: 26, job: "Engineer", name: "Ashok"}

## Binaries

Binaries are sequences of bytes enclosed in `<<` and `>>`:

    > <<1, 16, 128>>
    <<1, 16, 128>>

Values bigger than 255 (2⁸-1) are truncated:

    > <<255, 256, 257, 511, 512, 513>>
    <<255, 0, 1, 255, 0, 1>>

The amount of bits to be used for each value can be defined:

    > <<15::4>>
    <<15::size(4)>>
    > <<15::4, 12::4>>
    <<252>>

For the output, the two binaries 15 (1111) and 12 (1100) are normalized
(11111100), which results in the value 252.

A sequence of binaries only consisting of items with the size of a single bit is
called a bitstring:

    > <<1::1, 0::1, 1::1, 1::1>>
    <<11::size(4)>>

The bit sequence 1011 is a decimal 11 in the normalized form.

Multiple binaries can be combined using the `<>` operator:

    > <<1, 2, 3>> <> <<4, 5, 6>>
    <<1, 2, 3, 4, 5, 6>>

## Strings

Elixir has no dedicated string type, but stores them either as binaries or as
lists of characters.

### Binary Strings

Strings can be defined using double quotes:

    > name = "Dilbert"
    "Dilbert"

Expressions can be embedded into strings using `#{}` (string interpolation):

    > name = "Dilbert"
    > age = 42
    > profession = "Engineer"
    > description = "#{name} is a #{age} years old #{profession}."
    "Dilbert is a 42 years old Engineer."

Escape sequences such as `\t`, `\n`, `\r`, `\\`, and `\"` are supported, too.

Strings can also be defined using the sigil `~s()`, which allows the use of
unescaped double quotes within the string:

    > IO.puts(~s("Trust me, I'm an engineer!", Dilbert said.))
    "Trust me, I'm an engineer!", Dilbert said.

The sigil `~S()` ignores interpolation and escaping:

    > ~S(#{name} is a #{age} years old #{profession}.)
    "\#{name} is a \#{age} years old \#{profession}."
    > ~S(age:\t42 years)
    "age:\\t42 years"

The special heredoc syntax supports multi-line strings:

    > """
    > This is on a single line.
    > """
    "This is on a single line.\n"

Since strings are binaries, they can be concatenated using the `<>` operator:

    > profession = "Engineer"
    > "Dilbert's profession: " <> profession
    "Dilbert's profession: Engineer"

The [String](https://hexdocs.pm/elixir/String.html) module contains functions
for handling (UTF-8) strings.

### Character Lists

Strings can also be represented as lists of characters within single quotes:

    > 'ABC'
    'ABC'

Which is syntactic sugar for creating a list of their ASCII codes:

    > [65, 66, 67]
    'ABC'

If a list consists of numbers representing printable characters, it is displayed
as characters.

Character lists are incompatible to binary strings, but offer similar features
(escaping, interpolation, sigils, heredocs):

    > name = "Dilbert"
    > age = 42
    > IO.puts('Name:\t#{name}\nAge:\t#{age}')
    Name:   Dilbert
    Age:    42
    > IO.puts(~c('My name is #{name}', he said.))
    'My name is Dilbert', he said.
    > IO.puts(~C('My name is #{name}', he said.))
    'My name is #{name}', he said.

A character list can be converted into a binary string using `List.to_string/1`:

    > List.to_string('ABC')
    "ABC"

A binary string can be converted to a character list using
`String.to_charlist/1`:

    > String.to_charlist("ABC")
    'ABC'

In general, binary strings should be preferred to character lists. However, some
Erlang libraries require the use of character lists, in which case the
conversion functions above are helpful.

## First-Class Functions

Functions are first-class citizens; they can be assigned to a variable.

Anonymous functions or lambdas can be created using the `fn` keyword:

    > twice = fn x -> 2 * x end

Calling a lambda requires using the dot operator:

    > twice.(5)
    10

Functions can be passed to other functions, e.g. to process lists of items:

    > Enum.map([1, 2, 3], twice)
    [2, 4, 6]

The function argument can also be a function literal:

    > Enum.map([1, 2, 3], fn x -> 2 * x end)
    [2, 4, 6]

An existing function, like `IO.puts/1`, can be used as a lambda with the capture
operator `&`:

    > Enum.each([1, 2, 3], &IO.puts/1)
    1
    2
    3

Lambda expressions can be shortened by using the capture operator and by
referring to the n-th parameter as `&[n]` in the function definition:

    > Enum.map([1, 2, 3], &(2 * &1))
    [2, 4, 6]

### Closures

A lambda function captures variables bound at the time of its definition:

    > percentage = 75
    > get_percentage = fn x -> (percentage / 100) * x end
    > percentage = 99
    > Enum.map([1, 2, 3], get_percentage)
    [0.75, 1.5, 2.25]

The percentage 75 is used and not 99, because the first value was bound at the
time of the function definition.

## Higher-Level Types

### Ranges

A range of numbers can be expressed using the `..` notation:

    > numbers = 1..10

The `in` operator can be used to determine whether or not a number is within a
range:

    > 0 in numbers
    false
    > 10 in numbers
    true

A range is an enumerable, and, thus, can be processed using the functions of the
`Enum` module:

    > Enum.each(1..3, &IO.puts/1)
    1
    2
    3

### Keyword Lists

Some functions, such as `IO.inspect/2` expect optional arguments as a keyword
list, which can be constructed as a list of atom/value tuples:

    > options = [{:width, 3}, {:limit, 2}]
    > IO.inspect([100, 200, 300], options)
    [100,
     200,
     ...]

This alternative syntax makes the definition more elegant:

    > options = [width: 3, limit: 2]
    > IO.inspect([100, 200, 300], options)
    [100,
     200,
     ...]

Or even shorter without an intermediate variable and square brackets:

    > IO.inspect([100, 200, 300], width: 3, limit: 2)
    [100,
     200,
     ...]

To write functions using optional arguments, consider the
[Keyword](https://hexdocs.pm/elixir/Keyword.html) module (`salary.ex`):

```elixir
defmodule Salary do
  def pay_out(employee, salary, opts \\ []) do
    bonus = Keyword.get(opts, :bonus, 0)
    taxes = Keyword.get(opts, :taxes, 0)
    gross = salary + bonus
    net = gross - gross * taxes
    IO.puts("#{employee} earns $#{net}")
  end
end
```

The function `Salary.pay_out/3` now supports optional keywords:

    $ iex salary.ex
    > Salary.pay_out("Dilbert", 80000)
    Dilbert earns $80000
    > Salary.pay_out("Dilbert", 80000, bonus: 10000)
    Dilbert earns $90000
    > Salary.pay_out("Dilbert", 80000, bonus: 10000, taxes: 0.2)
    Dilbert earns $7.2e4

### MapSet

Sets only contain each value once and are implemented as a `MapSet` (module
[MapSet](https://hexdocs.pm/elixir/MapSet.html)):

    > numbers = MapSet.new([1, 3, 6])
    #MapSet<[1, 3, 6]>
    > numbers = MapSet.put(numbers, 2)
    #MapSet<[1, 2, 3, 6]>
    > numbers = MapSet.put(numbers, 3)
    #MapSet<[1, 2, 3, 6]>

A `MapSet` is an enumerable:

    > Enum.each(numbers, &IO.puts/1)
    1
    2
    3
    6

### Date and Time

Date and time objects can be conveniently be created using sigils:

    > today = ~D[2021-12-28]
    > today.year
    2021
    > today.month
    12
    > today.day
    28

    > lunch = ~T[12:30:00]
    lunch.hour
    > lunch.minute
    30
    > lunch.second
    0

The [Date](https://hexdocs.pm/elixir/Date.html) and
[Time](https://hexdocs.pm/elixir/Time.html) module contain useful functions to
work with those types.

Date and time can be combined to a _naive_ date time, i.e. without time zone:

    > lunch_today = ~N[2021-12-28 12:30:00]
    > lunch_today.year
    2021
    > lunch_today.minute
    30

A time zone can be added as follows:

    > lunch_today_utc = DateTime.from_naive!(lunch_today, "Etc/UTC")
    ~U[2021-12-28 12:30:00Z]
    > lunch_today_utc.time_zone
    "Etc/UTC"

See the modules [NaiveDateTime](https://hexdocs.pm/elixir/NaiveDateTime.html)
and [DateTime](https://hexdocs.pm/elixir/DateTime.html).

### IO Lists

IO lists are special kinds of lists to build up data for I/O incrementally,
which only must consist of integers (0..255), binaries, and other IO lists:

    > output = [[['F', 'o'], 'o'], "ba", 'r']
    > IO.puts(output)
    Foobar

Appending to a list is an O(n) operation, i.e. very efficient:

    > output = []
    []
    > output = [output, "Hello"]
    [[], "Hello"]
    > output = [output, ", "]
    [[[], "Hello"], ", "]
    > output = [output, "World!"]
    [[[[], "Hello"], ", "], "World!"]
    > IO.puts(output)
    Hello, World!

# Operators

Operators are implemented as functions of the `Kernel` module:

    > 3 + 5
    8
    > Kernel.+(3, 5)
    8

Instead of defining lambda functions:

    > Enum.reduce([1, 2, 3], fn x, y -> x + y end)
    6

The operator functions of the `Kernel` module can be used:

    > Enum.reduce([1, 2, 3], &Kernel.+/2)
    6

Or shorter (`Kernel` is imported automatically):

    > Enum.reduce([1, 2, 3], &+/2)
    6

There are comparison operators for weak and strict equality:

    > 1 == 1.0
    true
    > 1 === 1.0
    false

# Pattern Matching

The matching operator `=` is more powerful than an assignment operator in other
languages. A pattern on the left side matching the expression on the right side
creates variable bindings:

    > employee = {"Dilbert", 42}
    > {name, age} = employee

## Matching with Constants

The pattern can contain constants that must be matched:

    > dilbert = {:employee, "Dilbert", 42}
    > dogbert = {:consultant, "Dogbert", 7}
    > {:employee, name, _} = dilbert
    > name
    "Dilbert"
    > {:employee, name, _} = dogbert
    ** (MatchError) no match of right hand side value: {:consultant, "Dogbert", 7}

For values not to be bound, the anonymous variable (`_`) can be used in the
pattern to ignore them. A variable starting with `_` won't be bound, but has a
descriptive name:

    > {:employee, name, _age} = dilbert

Functions like `File.read/1` return a tuple of either the form `{:ok, value}` or
`{:error, reason}`, which can be matched accordingly:

    > File.read("/home/patrick/.vimrc")
    {:ok, "..."}
    > File.read("/home/patrick/.foobar")
    {:error, :enoent}

## Nested Patterns

Patterns can also be nested:

    > corporation = {:anycorp, {:ceo, "Pointy Haired Boss"}}
    > {:anycorp, {:ceo, ceo_name}} = corporation
    > ceo_name
    "Pointy Haired Boss"

## Re-using Bindings

For values that are expected to be the same, the same binding can be used
multiple times:

    > red_rgb = {255, 0, 0}
    > {red, other, other} = red_rgb
    > red
    255
    > {value, value, value} = red_rgb
    ** (MatchError) no match of right hand side value: {255, 0, 0}

## Pinning

For matching against the content of a variable, use the pin operator `^`:

    > redish_color = {255, 34, 78}
    > max_rgb = 255
    > {^max_rgb, green, blue} = redish_color
    > green
    34
    > blue
    78

## Matching Lists

Lists can be matched using individual elements:

    > [a, b, c] = [1, 2, 3]
    > a
    1

Or by splitting the head from the tail:

    > [head | tail] = [1, 2, 3]
    > head
    1
    > tail
    [2, 3]

## Matching Maps

Maps can be matched partially:

    > dilbert = %{name: "Dilbert", age: 42, job: "Engineer"}
    > %{name: name} = dilbert
    > name
    "Dilbert"

## Matching Binaries

Binaries can be matched completely:

    > numbers = <<1, 2, 3>>
    > <<a, b, c>> = numbers
    > c
    3

Or using a the special `:: binary` syntax:

    > <<first, rest :: binary>> = numbers
    > first
    1
    > rest
    <<2, 3>>

Or using a specified amounts of bits to be matched:

    > <<a :: 2, b :: 4, c :: 2>> = << 151 >>
    > a
    2
    > b
    5
    > c
    3

Here, 151 (`10010111`) is split into 2 (`10`), 5 (`0101`), and 3 (`11`).

## Matching Strings

Since strings are based on binaries, they can be matched the same:

    > <<a, b, c>> = "ABC"
    > a
    65
    > b
    66
    > c
    67

This is error-prone when dealing with unicode strings. Matching the beginning of
a string is more practical:

    > command = "ping paedubucher.ch"
    > "ping " <> domain = command
    > domain
    "paedubucher.ch"

## Compund Matches

Matches can be chained to extract values on different levels on a single line:

    > :calendar.local_time()
    {{2022, 1, 7}, {7, 37, 44}}
    > {{year, _, _}, {hour, _, _}} = {date, time} = now = :calendar.local_time()
    > year
    2022
    > hour
    7
    > date
    {2022, 1, 7}
    > time
    {7, 39, 4}
    > now
    {{2022, 1, 7}, {7, 39, 4}}

The sequence doesn't matter, as long as the patterns all match:

    > {date, time} = {{year, _, _}, {hour, _, _}} = now = :calendar.local_time()
    {{2022, 1, 7}, {7, 40, 26}}

TODO: p. 72 (Matching with functions)
