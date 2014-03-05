defmodule Stacker.Mixfile do
  use Mix.Project

  def project do
    [ app: :stacker,
      version: "0.0.1",
      elixir: "~> 0.12.4",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { Stacker, [] },
      applications: [
        :kernel,
        :stdlib,
        :sasl,
        :elixir,
        :lager
      ]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      { :lager, "~> 2.0.1", github: "basho/lager", tag: "2.0.1" },
      { :cuttlefish, github: "basho/cuttlefish", ref: "782eb539c3c4b71ed4d1299d764caa20b0447b62" },
      { :relx_cuttlefish, github: "potatosalad/relx_cuttlefish", tag: "0.0.1" }
    ]
  end
end
