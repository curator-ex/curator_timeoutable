defmodule CuratorTimeoutable do
  @moduledoc """
  CuratorTimeoutable: A curator module to handle user "timeouts".
  """

  import CuratorTimeoutable.Keys, only: [timeoutable_key: 1]
  import Curator.Time, only: [timestamp: 0]

  def set_timeoutable(conn, key) do
    Plug.Conn.put_session(conn, timeoutable_key(key), timestamp())
  end
end
