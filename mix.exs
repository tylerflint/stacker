Code.append_path "_build/#{Mix.env}/lib/relex/ebin"
Code.append_path "_build/#{Mix.env}/lib/pogo/ebin"

# this keeps the mixfile from breaking until we've installed our dependencies...
if Code.ensure_loaded?(Relex.Release) do
  defmodule Stacker.Release do
    use Relex.Release
    use Pogo.Release

    def name, do: "stacker"
    def applications, do: [:pogo, :stacker]
  end
end

defmodule Stacker.Mixfile do
  use Mix.Project

  def project do
    [ app: :stacker,
      version: "0.0.1",
      elixir: "~> 0.12.4",
      deps: deps,
      release: Stacker.Release,
      release_options: [
        path: "rel"
      ]
    ]
  end

  # Configuration for the OTP application
  def application do
    [mod: { Stacker, [] }]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:relex, github: "yrashk/relex"},
      {:pogo, github: "onkel-dirtus/pogo"}
    ]
  end
end
