defmodule Todo.Server do
  use GenServer

  def start() do
    GenServer.start(Todo.Server, nil)
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

  def init(_) do
    {:ok, Todo.List.new()}
  end

  def handle_cast({:add, entry}, state) do
    {:noreply, Todo.List.add_entry(state, entry)}
  end

  def handle_cast({:upd, entry_id, updater_fun}, state) do
    {:noreply, Todo.List.update_entry(state, entry_id, updater_fun)}
  end

  def handle_cast({:del, entry_id}, state) do
    {:noreply, Todo.List.delete_entry(state, entry_id)}
  end

  def handle_call({:get, date}, _, state) do
    {:reply, Todo.List.entries(state, date), state}
  end
end
