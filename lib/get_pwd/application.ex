defmodule GetPwd.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    user = :erlang.whereis(:user)
    [{:user_drv, user_drv}] = :group.interfaces(user)
    [{:current_group, shell}] = :user_drv.interfaces(user_drv)
    IO.inspect user
    IO.inspect user_drv
    IO.inspect shell
    IO.inspect :erlang.group_leader(shell, self)
    username = IO.gets(:standard_io, "Username: ")
    IO.inspect :erlang.group_leader(self, shell)
    IO.inspect username
    IO.inspect username
    IO.inspect username
    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: GetPwd.Worker.start_link(arg1, arg2, arg3)
      worker(GetPwd.KeyHolder, []),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GetPwd.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
