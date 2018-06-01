defmodule Timeularex.MixProject do
  use Mix.Project

  def project do
    [
      app: :timeularex,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Timeularex, []}
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0.0"},
      {:poison, "~> 3.1"}
    ]
  end
end
