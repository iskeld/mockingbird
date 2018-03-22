defmodule Mockingbird.Router do
  import Plug.Conn

  @behaviour Plug
  @channel "#random"

  def init([]), do: []

  def call(conn, _opts) do
    case conn.body_params do
      %{"type" => "url_verification", "challenge" => challenge} ->
        handle_url_verification(conn, challenge)

      %{
        "type" => "event_callback",
        "event" => %{
          "type" => "message",
          "channel" => "D" <> _channel,
          "subtype" => "file_share",
          "file" => file
        }
      } ->
        Task.start(fn -> handle_file_share(file) end)
        send_resp(conn, 200, "")

      %{
        "type" => "event_callback",
        "event" => %{"type" => "message", "channel" => "D" <> _channel, "text" => text}
      } ->
        handle_message(text)
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

  defp handle_file_share(%{"title" => title, "name" => name, "url_private_download" => url}) do
    with {:ok, data} <- download_file(url),
         {:ok, path} <- save_file(data, name) do
      upload_file(title, path)
      File.rm(path) 
    end
  end

  defp handle_file_share(_), do: :ok

  defp upload_file(title, path) do
    HTTPoison.post(
      "https://slack.com/api/files.upload",
      {:multipart,
       [
         {:file, path},
         {"token", Mockingbird.Config.bot_token()},
         {"title", title},
         {"channels", @channel}
       ]}
    )
  end

  defp download_file(url) do
    headers = [Authorization: "Bearer #{Mockingbird.Config.bot_token()}"]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      _ -> :error
    end
  end

  defp save_file(data, name) do
    path = Path.join(System.tmp_dir(), name)

    case File.write(path, data) do
      :ok -> {:ok, path}
      _ -> :error
    end
  end

  defp handle_message(message) do
    message = String.replace(message, "@channel", "<!channel>")

    body = %{
      "token" => Mockingbird.Config.bot_token(),
      "channel" => @channel,
      "text" => message,
      "as_user" => true
    }

    body_enc = URI.encode_query(body)

    HTTPoison.post!(
      "https://slack.com/api/chat.postMessage",
      body_enc,
      "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
    )
  end
end
