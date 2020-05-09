defmodule SimpleServer do
  def start_link(callback, init_args, opts) do
    server_pid =
      spawn_link(fn ->
        {:ok, state} = apply(callback, :init, [init_args])

        loop(callback, state)
      end)

    if opts[:name], do: Process.register(server_pid, opts[:name])

    {:ok, server_pid}
  end

  def call(server_pid, message) do
    send(server_pid, {:call, self(), message})

    receive do
      {:reply, reply} ->
        reply
    end
  end

  defp loop(callback, state) do
    receive do
      {:call, caller_pid, message} ->
        {:reply, reply, new_state} = apply(callback, :handle_call, [message, state])
        send(caller_pid, {:reply, reply})

        loop(callback, new_state)
    end
  end
end
