defmodule RustlerBenchmark.Elixir.Math do

  def factors_for(number), do: do_factors_for(number, 2)
  defp do_factors_for(1, _acc), do: []
  defp do_factors_for(number, acc) when rem(number, acc) == 0, do: [acc | do_factors_for(div(number, acc), acc)]
  defp do_factors_for(number, acc), do: do_factors_for(number, acc + 1)
end
