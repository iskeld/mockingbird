defmodule Mockingbird.Config do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> get_config() end, name: __MODULE__)
  end

  defp get_config() do
    %{
      bot_token: System.get_env("MOCKINGBIRD_BOT_TOKEN") || Application.get_env(:mockingbird, :bot_token),
      app_token: System.get_env("MOCKINGBIRD_APP_TOKEN") || Application.get_env(:mockingbird, :app_token)
    }
  end

  def bot_token() do
    Agent.get(__MODULE__, fn vars -> vars.bot_token end)
  end

  def app_token() do
    Agent.get(__MODULE__, fn vars -> vars.app_token end)
  end
end
