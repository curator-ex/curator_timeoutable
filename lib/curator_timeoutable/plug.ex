defmodule CuratorTimeoutable.Plug do
  @moduledoc """
  Use this hook to set a last_request_at timestamp, and signout if it's greater
  than a configured time
  """
  # import Plug.Conn
  import CuratorTimeoutable.Keys, only: [timeoutable_key: 1]

  def init(opts \\ %{}) do
    opts = Enum.into(opts, %{})

    %{
      key: Map.get(opts, :key, Curator.default_key),
      timeout_in: Map.get(opts, :timeout_in, CuratorTimeoutable.Config.timeout_in)
    }
  end

  def call(conn, opts) do
    key = Map.get(opts, :key)
    timeout_in = Map.get(opts, :timeout_in)

    case Curator.PlugHelper.current_resource(conn, key) do
      nil -> conn
      {:error, _error} -> conn
      _current_resource ->
        case verify(conn, timeout_in, key) do
          true -> set_timeoutable(conn, key)
          false -> Curator.PlugHelper.clear_current_resource_with_error(conn, "Session Timeout", key)
        end
    end
  end

  defp verify(conn, timeout_in, key) do
    last_request_at = Plug.Conn.get_session(conn, timeoutable_key(key))
    verify_exp(timeout_in, last_request_at)
  end

  defp verify_exp(_, nil), do: false

  defp verify_exp(timeout_in, last_request_at) do
    last_request_at + timeout_in > Curator.Time.timestamp
  end

  defp set_timeoutable(conn, key) do
    CuratorTimeoutable.set_timeoutable(conn, key)
  end
end
