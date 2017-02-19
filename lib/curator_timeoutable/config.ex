defmodule CuratorTimeoutable.Config do
  @moduledoc """
  The configuration for CuratorTimeoutable.

  ## Configuration

      config :curator_timeoutable, CuratorTimeoutable,
        timeout_in: 1800

  """

  def timeout_in, do: config(:timeout_in, 1800)

  @doc false
  def config, do: Application.get_env(:curator_timeoutable, CuratorTimeoutable, [])
  @doc false
  def config(key, default \\ nil),
    do: config() |> Keyword.get(key, default) |> resolve_config(default)

  defp resolve_config({:system, var_name}, default),
    do: System.get_env(var_name) || default
  defp resolve_config(value, _default),
    do: value
end
