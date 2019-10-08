defmodule Committee.MixProject do
  use Mix.Project

  def project do
    [
      app: :committee,
      version: "0.1.2",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Committee",
      description: description(),
      package: package(),
      source_url: "https://github.com/edisonywh/committee"
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
      {:ex_doc, "~> 0.21.2", only: :dev},
      {:earmark, "~> 1.4", only: :dev}
    ]
  end

  def description do
    "⚡️Committee is a supercharged git hooks manager in pure Elixir"
  end

  def package do
    [
      maintainers: ["Edison Yap"],
      licenses: ["MIT"],
      links: %{GitHub: "https://github.com/edisonywh/committee"}
    ]
  end
end
