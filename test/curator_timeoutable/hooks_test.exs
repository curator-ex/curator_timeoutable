defmodule CuratorTimeoutable.HooksTest do
  use ExUnit.Case, async: true
  doctest CuratorTimeoutable.Hooks

  use Plug.Test
  import CuratorTimeoutable.PlugHelper

  setup do
    conn = conn_with_fetched_session(conn(:get, "/"))
    {:ok, %{conn: conn}}
  end

  test "after_sign_in with a session", %{conn: conn} do
    conn = conn
    |> CuratorTimeoutable.Hooks.after_sign_in(%{}, :default)

    assert Plug.Conn.get_session(conn, :guardian_default_timeoutable) > 0
  end
end
