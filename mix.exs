defmodule ElxParser.Mixfile do
  use Mix.Project

  def project do
    [app: :elxparser,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  defp deps do
    []
  end

  defp package do
      [# These are the default files included in the package
        name: :elxparser,
        files: ["lib", "test", "mix.exs", "config.exs", "README*", "LICENSE*"],
        maintainers: ["Kota Mizushima"],
        licenses: ["MIT License"],
        links: %{"GitHub" => "https://github.com/kmizu/elxparser"}]
  end
end
