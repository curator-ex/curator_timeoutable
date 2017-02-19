defmodule CuratorTimeoutable.Hooks do
  @moduledoc """
  This module hooks into the curator lifecycle.
  """

  use Curator.Hooks

  def after_sign_in(conn, _user, key) do
    # if conn.private[:plug_session] do
    #  CuratorTimeoutable.set_timeoutable(conn, key)
    # end

    CuratorTimeoutable.set_timeoutable(conn, key)
  end
end
