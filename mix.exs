defmodule JsonPathAccess.MixProject do
  use Mix.Project

  def project do
    [
      app: :json_path_access,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Converts JSONPath expressions into Access list.",
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/vrcca/json_path_access/"},
      source_url: "https://github.com/vrcca/json_path_access/",
      homepage_url: "https://github.com/vrcca/json_path_access/"
    }
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_parsec, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
