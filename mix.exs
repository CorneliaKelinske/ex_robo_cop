defmodule ExRoboCop.MixProject do
  use Mix.Project

  @version "0.1.4"

  def project do
    [
      app: :ex_robo_cop,
      version: @version,
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        dialyzer: :test,
        coveralls: :test,
        doctor: :test,
        credo: :test,
        docs: :test,
        check: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.lcov": :test
      ],
      dialyzer: [
        plt_add_apps: [:ex_unit, :mix],
        list_unused_filters: true,
        plt_local_path: "dialyzer",
        plt_core_path: "dialyzer",
        flags: [:unmatched_returns, :no_improper_lists]
      ],

      # Hex
      description: description(),
      package: package(),

      # Docs
      name: "ExRoboCop",
      docs: docs()
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
    A lightweight captcha text generator using Rust
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
        "README.md",
        "CHANGELOG.md"
      ]
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "README",
      canonical: "http://hexdocs.pm/ex_robo_cop",
      source_url: "https://github.com/CorneliaKelinske/ex_robo_cop",
      filter_prefix: "ExRoboCop",
      extras: [
        "README.md": [filename: "README"],
        "CHANGELOG.md": [filename: "CHANGELOG"]
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.33.0"},
      {:uuid, "~> 1.1"},
      {:dialyxir, "~> 1.1", only: :test, runtime: false},
      {:ex_check, "~> 0.16.0", only: :test, runtime: false},
      {:credo, "~> 1.5", only: :test, runtime: false},
      {:ex_doc, "~> 0.32.1", only: [:test, :dev], runtime: false},
      {:doctor, "~> 0.21.0", only: :test},
      {:excoveralls, "~> 0.10", only: :test}
    ]
  end
end
