defmodule CommitteeTest do
  use ExUnit.Case
  doctest Committee

  test "greets the world" do
    assert Committee.hello() == :world
  end
end
