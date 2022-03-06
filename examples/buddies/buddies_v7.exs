defmodule ServerProcess do
  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)
  end

  def call(server_pid, request) do
    send(server_pid, {:call, request, self()})

    receive do
      {:response, response} -> response
    end
  end

  def cast(server_pid, request) do
    send(server_pid, {:cast, request})
  end

  defp loop(callback_module, current_state) do
    receive do
      {:call, request, caller} ->
        {response, new_state} =
          callback_module.handle_call(
            request,
            current_state
          )

        send(caller, {:response, response})
        loop(callback_module, new_state)

      {:cast, request} ->
        new_state =
          callback_module.handle_cast(
            request,
            current_state
          )

        loop(callback_module, new_state)
    end
  end
end

defmodule Buddies do
  defstruct auto_id: 1, entries: %{}

  def start() do
    ServerProcess.start(Buddies)
  end

  def add_entry(pid, entry) do
    ServerProcess.cast(pid, {:add, entry})
  end

  def entries(pid, city) do
    ServerProcess.call(pid, {:get, city})
  end

  def update_entry(pid, entry_id, updater_fun) do
    ServerProcess.cast(pid, {:upd, entry_id, updater_fun})
  end

  def delete_entry(pid, entry_id) do
    ServerProcess.cast(pid, {:del, entry_id})
  end

  def init() do
    %Buddies{}
  end

  def handle_cast({:add, entry}, state) do
    entry = Map.put(entry, :id, state.auto_id)
    new_entries = Map.put(state.entries, state.auto_id, entry)
    %Buddies{state | entries: new_entries, auto_id: state.auto_id + 1}
  end

  def handle_cast({:upd, entry_id, updater_fun}, state) do
    case Map.fetch(state.entries, entry_id) do
      :error ->
        state

      {:ok, old_entry} ->
        new_entry = %{id: ^entry_id} = updater_fun.(old_entry)
        new_entries = Map.put(state.entries, entry_id, new_entry)
        %Buddies{state | entries: new_entries}
    end
  end

  def handle_cast({:del, entry_id}, state) do
    new_entries = Map.filter(state.entries, fn {_, e} -> e.id != entry_id end)
    %Buddies{state | entries: new_entries}
  end

  def handle_call({:get, city}, state) do
    found_entries =
      state.entries
      |> Stream.filter(fn {_, entry} -> entry.city == city end)
      |> Enum.map(fn {_, entry} -> entry end)

    {found_entries, state}
  end
end

pid = Buddies.start()

IO.puts("adding some buddies")
Buddies.add_entry(pid, %{city: "Berlin", name: "Hans"})
Buddies.add_entry(pid, %{city: "Berlin", name: "Hermann"})
Buddies.add_entry(pid, %{city: "Palermo", name: "Vito"})

IO.puts("entries from Berlin")
Enum.each(Buddies.entries(pid, "Berlin"), &IO.inspect/1)

IO.puts("entries from Berlin after deleting entry with id 2")
Buddies.delete_entry(pid, 2)
Enum.each(Buddies.entries(pid, "Berlin"), &IO.inspect/1)

IO.puts("entries from Palermo after updating entry with id 3")
Buddies.update_entry(pid, 3, fn e -> Map.put(e, :name, "Don Corleone") end)
Enum.each(Buddies.entries(pid, "Palermo"), &IO.inspect/1)
