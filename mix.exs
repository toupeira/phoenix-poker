defmodule PhoenixPoker.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_poker,
      version: "0.0.1",
      elixir: "~> 1.0",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases,
      deps: deps,
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PhoenixPoker, []},
      applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext],
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.0-rc.0"},
      {:phoenix_pubsub, "~> 1.0.0-rc"},
      {:phoenix_html, "~> 2.5"},
      {:gettext, "~> 0.9"},
      {:cowboy, "~> 1.0"},
      {:uuid, "~> 1.1"},

      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:dogma, "~> 0.1", only: :dev},
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    []
  end
end
