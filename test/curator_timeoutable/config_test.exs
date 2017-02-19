defmodule CuratorTimeoutable.ConfigTest do
  use ExUnit.Case, async: true
  doctest CuratorTimeoutable.Config

  test "the default timeout_in" do
    assert CuratorTimeoutable.Config.timeout_in == 1800
  end
end
