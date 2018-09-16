defmodule Mockingbird.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = Application.get_env(:mockingbird, :port)

    children = [
      Mockingbird.Config,
      {Plug.Adapters.Cowboy2, scheme: :http, plug: Mockingbird.Handler, options: [port: port]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mockingbird.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
