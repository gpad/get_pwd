defmodule GetPwd.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp get_shell() do
    user = :erlang.whereis(:user)

    case :group.interfaces(user) do
      [{:user_drv, user_drv}] ->
        [{:current_group, shell}] = :user_drv.interfaces(user_drv)
        shell
      [] ->
        IO.puts ":group.interfaces(user) ret: empty ..."
        case :user.interfaces(user) do
          [{:shell, shell}] ->
            shell
          _ ->
            IO.puts ":user.interfaces(user) ret: empty ..."
            nil
        end
      _ -> nil
    end
  end

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    shell = get_shell()
    shell && :erlang.group_leader(shell, self())

    username = IO.gets(:standard_io, "Username: ")
    # IO.write :standard_io, "Username: "
    # username = :io.get_password() |> to_string
    password = IO.gets(:standard_io, "Password: ")
    # IO.write :standard_io, "Password: "
    # password = :io.get_password() |> to_string

    shell && :erlang.group_leader(self(), shell)

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: GetPwd.Worker.start_link(arg1, arg2, arg3)
      worker(GetPwd.KeyHolder, [username, password]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GetPwd.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
