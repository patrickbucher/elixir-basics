defmodule Credentials do
  def extract(employee) do
    with {:ok, username} <- extract_username(employee),
         {:ok, email} <- extract_email(employee),
         {:ok, password} <- extract_password(employee) do
      %{username: username, email: email, password: password}
    end
  end

  def extract_old(employee) do
    case extract_username(employee) do
      {:error, reason} ->
        {:error, reason}

      {:ok, username} ->
        case extract_email(employee) do
          {:error, reason} ->
            {:error, reason}

          {:ok, email} ->
            case extract_password(employee) do
              {:error, reason} ->
                {:error, reason}

              {:ok, password} ->
                %{username: username, email: email, password: password}
            end
        end
    end
  end

  defp extract_username(%{"username" => username}), do: {:ok, username}
  defp extract_username(_), do: {:error, "username missing"}

  defp extract_email(%{"email" => email}), do: {:ok, email}
  defp extract_email(_), do: {:error, "email missing"}

  defp extract_password(%{"password" => password}), do: {:ok, password}
  defp extract_password(_), do: {:error, "password missing"}
end

employees = [
  %{
    "name" => "Dilbert",
    "username" => "dilbo",
    "password" => "Uyee7oox0OK8johG",
    "email" => "dilbo@corp.com",
    "age" => 42
  },
  %{
    "name" => "Pointy Haired Boss",
    "username" => "theboss",
    "email" => "boss@corp.com",
    "age" => 52,
    "golf_handicap" => 17,
    "cars_owned" => 3
  },
  %{
    "name" => "Wally",
    "username" => "lazybone",
    "password" => "qwerty",
    "email" => "wally@corp.com",
    "age" => 47,
    "years_wasted" => 27
  },
  %{
    "name" => "Dogbert",
    "email" => "doggo@corp.com",
    "age" => 13,
    "current_lawsuits" => 3,
    "allegations" => ["fraud", "arson", "tax evasion"]
  },
  %{
    "name" => "Alice",
    "username" => "alicepro",
    "password" => "IHateThisPlace",
    "email" => "alice@corp.com",
    "age" => 39
  },
  %{
    "name" => "Catbert",
    "username" => "thecat",
    "password" => "23jd92039d20",
    "age" => 11,
    "years_in_jail" => 5,
    "former_employers" => ["aramco", "facebook"]
  }
]

employees |> Enum.map(&Credentials.extract/1) |> Enum.each(&IO.inspect/1)
