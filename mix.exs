defmodule FacebookMessenger.Mixfile do
  use Mix.Project

  def project do
    [app: :facebook_messenger,
     name: "ExFacebookMessenger",
     source_url: "https://github.com/oarrabi/facebook_messenger",
     version: "0.3.0",
     docs: [ extras: ["README.md"] ],
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: Coverex.Task, coveralls: true],
     deps: deps,
     package: package,
     description: description]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :httpotion]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    d = [{:httpotion, "~> 3.0.2"},
         {:plug, "> 0.0.0"},
         {:inch_ex, "> 0.0.0", only: :docs},
         {:ex_doc, "~> 0.7", only: :dev},
         {:earmark, "~> 0.1", only: :docs}]

    if Mix.env == :test do
      [{:coverex, "~> 1.4.8", only: :test}, {:poison, "~> 2.1.0 or ~> 3.0", override: true} | d]
    else
      [{:poison, "~> 2.1.0 or ~> 3.0"} | d]
    end
  end

  defp description do
    """
    ExFacebookMessenger is a library that easy the creation of facebook messenger bots.
    """
  end

  defp package do
    [ files: [ "lib", "mix.exs", "README.md",],
      maintainers: [ "Omar Abdelhafith" ],
      links: %{ "GitHub" => "https://github.com/oarrabi/facebook_messenger" } ]
  end
end
