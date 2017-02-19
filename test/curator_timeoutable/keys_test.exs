defmodule CuratorTimeoutable.KeysTest do
  use ExUnit.Case, async: true
  doctest CuratorTimeoutable.Keys

  test "timeoutable_key" do
    assert CuratorTimeoutable.Keys.timeoutable_key(:foo) == :curator_foo_timeoutable
  end
end
