defmodule Todo.Server do
  use GenServer

  def start(list_name) do
    IO.puts("Starting to-do server for #{list_name}")
    GenServer.start(Todo.Server, list_name)
  end

  def add_entry(pid, entry) do
    GenServer.cast(pid, {:add, entry})
  end

  def update_entry(pid, entry_id, updater_fun) do
    GenServer.cast(pid, {:upd, entry_id, updater_fun})
  end

  def delete_entry(pid, entry_id) do
    GenServer.cast(pid, {:del, entry_id})
  end

  def entries(pid, date) do
    GenServer.call(pid, {:get, date})
  end

  def init(list_name) do
    {:ok, {list_name, Todo.Database.get(list_name) || Todo.List.new()}}
  end

  def handle_cast({:add, entry}, state) do
    {name, old_list} = state
    new_list = Todo.List.add_entry(old_list, entry)
    Todo.Database.store(name, new_list)
    {:noreply, {name, new_list}}
  end

  def handle_cast({:upd, entry_id, updater_fun}, state) do
    {name, list} = state
    {:noreply, {name, Todo.List.update_entry(list, entry_id, updater_fun)}}
  end

  def handle_cast({:del, entry_id}, state) do
    {name, list} = state
    {:noreply, {name, Todo.List.delete_entry(list, entry_id)}}
  end

  def handle_call({:get, date}, _, state) do
    {_, list} = state
    {:reply, Todo.List.entries(list, date), state}
  end
end
