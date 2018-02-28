defmodule Mockingbird.TokenValidator do
  alias Plug.Conn

  @behaviour Plug

  def init(opts) do
    Keyword.get(opts, :token, Application.get_env(:mockingbird, :token))
  end

  def call(conn, token) do
    case conn.body_params do
      %{"token" => ^token} -> conn
      %Plug.Conn.Unfetched{} -> raise "Unfetched"
      _ -> conn |> send_resp(401, "") |> halt()
    end
  end
end
