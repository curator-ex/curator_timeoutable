defmodule CuratorTimeoutable.PlugTest do
  use ExUnit.Case, async: true
  doctest CuratorTimeoutable.Plug

  use Plug.Test

  import CuratorTimeoutable.PlugHelper
  import CuratorTimeoutable.Keys

  setup do
    conn = conn_with_fetched_session(conn(:get, "/"))
    {:ok, %{conn: conn}}
  end

  test "with no timeoutable_key in the session", %{conn: conn} do
    user = %{}

    conn = conn
    |> Guardian.Plug.set_claims({:ok, %{claims: "default"}})
    |> Curator.PlugHelper.set_current_resource(user)
    |> run_plug(CuratorTimeoutable.Plug)

    refute Curator.PlugHelper.current_resource(conn)
    assert Guardian.Plug.claims(conn, :default) == {:error, "Session Timeout"}
  end

  test "with a valid timeoutable_key in the session at the default location", %{conn: conn} do
    user = %{}

    conn = conn
    |> Guardian.Plug.set_claims({:ok, %{claims: "default"}})
    |> Curator.PlugHelper.set_current_resource(user)
    |> Plug.Conn.put_session(timeoutable_key(), Curator.Time.timestamp)
    |> run_plug(CuratorTimeoutable.Plug)

    assert Curator.PlugHelper.current_resource(conn)
    assert Guardian.Plug.claims(conn) == {:ok, %{claims: "default"}}
  end

  test "with a valid timeoutable_key in the session at a specified location", %{conn: conn} do
    user = %{}

    conn = conn
    |> Guardian.Plug.set_claims({:ok, %{claims: "default"}}, :secret)
    |> Curator.PlugHelper.set_current_resource(user, :secret)
    |> Plug.Conn.put_session(timeoutable_key(:secret), Curator.Time.timestamp)
    |> run_plug(CuratorTimeoutable.Plug, %{key: :secret})

    assert Curator.PlugHelper.current_resource(conn, :secret)
    assert Guardian.Plug.claims(conn, :secret) == {:ok, %{claims: "default"}}
  end

  test "with an expired timeoutable_key in the session at the default location", %{conn: conn} do
    user = %{}

    conn = conn
    |> Guardian.Plug.set_claims({:ok, %{claims: "default"}})
    |> Curator.PlugHelper.set_current_resource(user)
    |> Plug.Conn.put_session(timeoutable_key(), Curator.Time.timestamp)
    |> run_plug(CuratorTimeoutable.Plug, %{timeout_in: -1})

    refute Curator.PlugHelper.current_resource(conn)
    assert Guardian.Plug.claims(conn) == {:error, "Session Timeout"}
  end

  test "with no user", %{conn: conn} do
    conn = conn
    |> Guardian.Plug.set_claims({:ok, %{claims: "default"}})
    |> run_plug(CuratorTimeoutable.Plug)

    refute Curator.PlugHelper.current_resource(conn)
    assert Guardian.Plug.claims(conn) == {:ok, %{claims: "default"}}
  end
end
