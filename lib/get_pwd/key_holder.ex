defmodule GetPwd.KeyHolder do
  use GenServer

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    # IO.puts ">> #{Mix.shell()}"
    username = System.get_env("GP_USERNAME") #|| IO.gets("Username: ")
    password = System.get_env("GP_PASSWORD") #|| IO.gets("Password: ")
    # username = System.get_env("GP_USERNAME") || Mix.shell().prompt("Username: ")
    # password = System.get_env("GP_PASSWORD") || Mix.shell().prompt("Password: ")
    #username = System.get_env("GP_USERNAME") #|| IO.gets("Username: ")
    #password = System.get_env("GP_PASSWORD") #|| IO.gets("Password: ")
    IO.puts "Group leader: #{inspect Process.group_leader()}"
    :timer.apply_interval(5000, __MODULE__, :get, [])
    {:ok, %{username: username, password: password}}
  end

  def get() do
    ret = GenServer.call(@name, :get)
    IO.puts ">> ret: #{inspect ret}"
  end

  def handle_call(:get, _from, state) do
    IO.puts "type usernam #{inspect :io.getopts(:standard_io) }..."

    # IO.puts "Group leader: #{inspect Process.group_leader()}"
    username = System.get_env("GP_USERNAME") || IO.gets("Username: ")
    IO.puts "Inserted username: #{inspect username}"
    password = System.get_env("GP_PASSWORD") || IO.gets("Password: ")
    IO.puts "Inserted password: #{inspect password}"
    {:reply, {username, password}, %{state | username: username, password: password}}
  end

end
