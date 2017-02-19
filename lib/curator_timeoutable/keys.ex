defmodule CuratorTimeoutable.Keys do
  @moduledoc """
  """

  import Curator.Keys

  def timeoutable_key(key \\ :default) do
    String.to_atom("#{base_key(key)}_timeoutable")
  end
end
