defmodule RustlerBenchmark.Rust.Math do
  use Rustler, otp_app: :rustler_benchmark, crate: "rustlerbenchmark_math"

  # version = Mix.Project.config()[:version]

  # use RustlerPrecompiled,
  #   otp_app: :rustler_precompilation_example,
  #   crate: "example",
  #   base_url:
  #     "https://github.com/philss/rustler_precompilation_example/releases/download/v#{version}",
  #   force_build: System.get_env("RUSTLER_PRECOMPILATION_EXAMPLE_BUILD") in ["1", "true"],
  #   version: version

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)

  def factors(_a), do: :erlang.nif_error(:nif_not_loaded)
end
