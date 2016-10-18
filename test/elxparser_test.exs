defmodule ElxParserTest do
  use ExUnit.Case
  import ElxParser
  doctest ElxParser

  test "parser" do
    hello = s("Hello, ")
    assert {:success, "Hello, ", "World"} == hello.("Hello, World")
  end
end
