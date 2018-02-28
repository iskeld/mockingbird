defmodule Mockingbird.Router do
  import Plug.Conn

  @behaviour Plug

  def init(opts) do
    Keyword.get(opts, :token, Application.get_env(:mockingbird, :bot_token))
  end

  def call(conn, token) do
    case conn.body_params do
      %{"type" => "url_verification", "challenge" => challenge} ->
        handle_url_verification(conn, challenge)

      %{
        "type" => "event_callback",
        "event" => %{"type" => "message", "channel" => "D" <> _channel, "text" => text}
      } ->
        handle_message(text, token)
        send_resp(conn, 200, "")

      _ ->
        send_resp(conn, 200, "")
    end
  end

  defp handle_url_verification(conn, challenge) do
    response = URI.encode_query(%{"challenge" => challenge})

    conn
    |> put_resp_content_type("application/x-www-form-urlencoded")
    |> send_resp(200, response)
  end

  defp handle_message(message, token) do
    body = %{
      "token" => token,
      "channel" => "#test",
      "text" => message,
      "as_user" => true
    }

    body_enc = URI.encode_query(body)

    HTTPotion.post!(
      "https://slack.com/api/chat.postMessage",
      body: body_enc,
      headers: ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    )
  end
end
