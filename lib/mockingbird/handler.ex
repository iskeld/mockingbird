defmodule Mockingbird.Handler do
  use Plug.Builder

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison

  plug Mockingbird.TokenValidator

  plug Mockingbird.Router
end
