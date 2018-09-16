defmodule Mockingbird.MixProject do
  use Mix.Project

  def project do
    [
      app: :mockingbird,
      version: "0.1.2",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Mockingbird.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.4"},
      {:plug, "~> 1.6"},
      {:poison, "~> 4.0"},
      {:httpoison, "~> 1.3"},
      {:distillery, "~> 2.0", runtime: false}
    ]
  end
end
