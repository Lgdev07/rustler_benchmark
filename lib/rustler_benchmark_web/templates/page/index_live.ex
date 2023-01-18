defmodule RustlerBenchmarkWeb.IndexLive do
  @moduledoc false

  use Phoenix.LiveView
  use Phoenix.HTML

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(elixir: "")
      |> assign(rust: "")
      |> assign(benchmark: "")
      |> assign(input_value: "")
      |> assign(error: nil)

    {:ok, socket}
  end

  @impl true
  def handle_event("benchmark_sync", _value, %{assigns: %{input_value: input_value}} = socket) do
    Benchee.run(%{
      "elixir" => fn ->
        RustlerBenchmark.Elixir.Math.factors_for(String.to_integer(input_value))
      end,
      "rust" => fn -> RustlerBenchmark.Rust.Math.factors(String.to_integer(input_value)) end
    })

    {:noreply, socket}
  end

  @impl true
  def handle_event("validate", %{"input_value" => input_value}, socket) do
    {:noreply, assign(socket, input_value: input_value)}
  end

  @impl true
  def handle_event(_action, %{"input_value" => input_value}, socket) do
    view_pid = self()

    spawn(fn ->
      send(view_pid, {:rust_factor_done, ["Loading"], "Loading"})

      {time_in_microseconds, ret_val} =
        :timer.tc(fn -> RustlerBenchmark.Rust.Math.factors(String.to_integer(input_value)) end)

      send(view_pid, {:rust_factor_done, ret_val, time_in_microseconds})
    end)

    spawn(fn ->
      send(view_pid, {:elixir_factor_done, ["Loading"], "Loading"})

      {time_in_microseconds, ret_val} =
        :timer.tc(fn ->
          RustlerBenchmark.Elixir.Math.factors_for(String.to_integer(input_value))
        end)

      send(view_pid, {:elixir_factor_done, ret_val, time_in_microseconds})
    end)

    {:noreply, assign(socket, input_value: input_value)}
  end

  @impl true
  def handle_info({:elixir_factor_done, result, time}, socket) do
    return = "Elixir: #{time} microseconds
Prime factors: #{Enum.join(result, ", ")}"

    {:noreply, assign(socket, elixir: return)}
  end

  @impl true
  def handle_info({:rust_factor_done, result, time}, socket) do
    return = "Rust: #{time} microseconds
Prime factors: #{Enum.join(result, ", ")}"

    {:noreply, assign(socket, rust: return)}
  end
end
