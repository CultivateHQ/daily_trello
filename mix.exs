defmodule DailyTrello.Mixfile do
  use Mix.Project

  def project do
    [app: :daily_trello,
     version: "0.0.2",
     elixir: "~> 1.0.0",
     escript: escript_config,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison, :jsx]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:mock, git: "git@github.com:jjh42/mock.git"},
      { :httpoison, "~> 0.3" },
      { :jsxn,       "~> 0.2.1" },
    ]
  end


  defp escript_config do
    [ main_module: DailyTrello.CLI ]
  end
end
