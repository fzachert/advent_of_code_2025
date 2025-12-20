defmodule AdventOfCode.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_of_code,
      version: "0.1.0",
      elixir: "~> 1.12",
      deps: deps()
    ]
  end

  defp deps do
    [{:libgraph, "~> 0.16.0"}]
  end
end