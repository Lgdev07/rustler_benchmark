defmodule RustlerBenchmark.Rust.Math do
  use Rustler, otp_app: :rustler_benchmark, crate: "rustlerbenchmark_math"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)

  def factors(_a), do: :erlang.nif_error(:nif_not_loaded)
end
