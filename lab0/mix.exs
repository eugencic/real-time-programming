defmodule Lab0.MixProject do
  use Mix.Project

  def project do
    [
      app: :lab0,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 2.0"},
      {:floki, ">= 0.34.0"},
      {:jason, "~> 1.2"}
    ]
  end
end
