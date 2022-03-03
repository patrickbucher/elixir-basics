defmodule BankAccount do
  def pay_async(pid, payment) do
    case payment do
      {:incoming, amount} -> send(pid, {:pay_in, amount, self()})
      {:outgoing, amount} -> send(pid, {:pay_out, amount, self()})
    end
  end

  def query_balance(pid) do
    send(pid, {:query, self()})
  end

  def get_result() do
    receive do
      {:ok, balance} -> {:ok, balance}
    after
      1000 -> {:err, :timeout}
    end
  end

  def start(balance) do
    spawn(fn -> loop(balance) end)
  end

  defp loop(balance) do
    balance =
      receive do
        {:query, pid} ->
          send(pid, {:ok, balance})
          balance

        {:pay_in, amount, _} ->
          balance + amount

        {:pay_out, amount, _} ->
          new_balance = balance - amount

          if new_balance >= 0 do
            new_balance
          else
            balance
          end
      end

    loop(balance)
  end
end

accounts = %{
  "Dilbert" => BankAccount.start(25_200),
  "Alice" => BankAccount.start(52_900),
  "Wally" => BankAccount.start(12_500)
}

# random spending 1..1000
1..50
|> Enum.each(fn _ ->
  {name, account} = Enum.random(accounts)
  amount = :rand.uniform(1000)
  BankAccount.pay_async(account, {:outgoing, amount})
  IO.puts("#{name} spent #{amount}.")
end)

# random salary 7000..9000
accounts
|> Enum.each(fn {name, account} ->
  salary = :rand.uniform(2000) + 7000
  BankAccount.pay_async(account, {:incoming, salary})
  IO.puts("#{name} received a salary of #{salary}.")
end)

accounts
|> Enum.each(fn {name, account} ->
  BankAccount.query_balance(account)

  case BankAccount.get_result() do
    {:ok, balance} ->
      IO.puts("At the end of the month, #{name} has a balance of #{balance}.")

    {:err, :timeout} ->
      IO.puts("Retrieval of balance of #{name}'s account failed with a timeout.")
  end
end)
