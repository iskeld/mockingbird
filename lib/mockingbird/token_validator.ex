defmodule Mockingbird.TokenValidator do
  import Plug.Conn

  @behaviour Plug

  def init([]), do: []

  def call(conn, _opts) do
    token = Mockingbird.Config.app_token()
    case conn.body_params do
      %{"token" => ^token} -> conn
      %Plug.Conn.Unfetched{} -> raise "Unfetched"
      _ -> conn |> send_resp(401, "") |> halt()
    end
  end
end
