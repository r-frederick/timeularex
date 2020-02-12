defmodule Timeularex.MixProject do
  use Mix.Project

  def project do
    [
      app: :timeularex,
      version: "0.1.2",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
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
      {:httpoison, "~> 1.6.2"},
      {:poison, "~> 3.1"},
      {:ex_doc, ">= 0.21.0", only: :dev}
    ]
  end

  defp description() do
    "A Timeular API client."
  end

  defp package() do
    [
      maintainers: ["Ridge Frederick"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/r-frederick/timeularex"}
    ]
  end
end
