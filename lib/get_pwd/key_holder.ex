defmodule GetPwd.KeyHolder do
  use GenServer

  @name __MODULE__

  def start_link(username, password) do
    # IO.puts ">>> start-link #{username} - #{password}"
    GenServer.start_link(__MODULE__, [username, password], name: @name)
  end

  def init([username, password]) do
    # IO.puts ">>> init1 #{inspect username} - #{inspect password}"
    :timer.apply_after(5000, __MODULE__, :get, [])
    {:ok, %{username: username, password: password, count: 1}}
  end

  def init(username, password) do
    # IO.puts ">>> init2 #{inspect username} - #{inspect password}"
    :timer.apply_interval(5000, __MODULE__, :get, [])
    {:ok, %{username: username, password: password}}
  end

  def get() do
    # IO.puts "Get state ..."
    ret = GenServer.call(@name, :get)
  end

  def handle_call(:get, _from, state) do
    IO.puts ">>> handle call username: #{inspect state.username} - #{inspect state.password}"
    if (rem(state.count, 3) == 0) do
      # {:ok} = {:error}
    end
    :timer.apply_after(5000, __MODULE__, :get, [])
    {:reply, {state.username, state.password}, %{state | count: state.count + 1}}
  end

end
