defmodule ExRoboCop.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_robo_cop,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      preferred_cli_env: [
        dialyzer: :test
      ],
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    A simple captcha text generator using Rust
    """
  end

  defp package do
    [
      maintainers: ["Cornelia Kelinske"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/corneliakelinske/ex_robo_cop"},
      files: [
        "lib/ex_robo_cop.ex",
        "lib/ex_robo_cop",
        "native/rustcaptcha",
        "mix.exs",
        "README.md"
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.22.2"},
      {:uuid, "~> 1.1"},
      {:dialyxir, "~> 1.1", only: [:test], runtime: false},
      {:ex_check, "~> 0.14.0", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end
end
