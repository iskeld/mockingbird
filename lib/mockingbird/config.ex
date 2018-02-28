defmodule Mockingbird.Config do
  def bot_token() do
    System.get_env("MOCKINGBIRD_BOT_TOKEN") || Application.get_env(:mockingbird, :bot_token)
  end

  def app_token() do
    System.get_env("MOCKINGBIRD_APP_TOKEN") || Application.get_env(:mockingbird, :app_token)
  end
end
