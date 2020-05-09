defmodule MyServer do
  def start_link() do
    SimpleServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, 1}
  end

  def handle_call({:add, num}, current_state) do
    new_state = current_state + num

    {:reply, new_state, new_state}
  end

  def handle_call(:get_state, current_state) do
    {:reply, current_state, current_state}
  end

  def handle_cast({:add, num}, current_state) do
    new_state = current_state + num

    {:noreply, new_state}
  end
end
