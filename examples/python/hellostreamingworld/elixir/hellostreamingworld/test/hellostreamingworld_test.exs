defmodule HellostreamingworldTest do
  use ExUnit.Case
  doctest Hellostreamingworld

  test "greets the world" do
    assert Hellostreamingworld.hello() == :world
  end
end
