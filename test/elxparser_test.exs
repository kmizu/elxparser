defmodule ElxParserTest do
  use ExUnit.Case
  import ElxParser
  doctest ElxParser

  def e do
    rule(fn ->
      a
    end)
  end

  def a do
    rule(fn ->
      chainl(
        m,
        map(s("+"), fn _ -> 
          fn lhs, rhs ->
            lhs + rhs
          end
        end) <|>
        map(s("-"), fn _ -> 
          fn lhs, rhs ->
            lhs - rhs
          end
        end)
      )
    end)
  end

  def m do
    rule(fn ->
      chainl(
        p,
        map(s("*"), fn _ -> 
          fn lhs, rhs ->
            lhs * rhs
          end
        end) <|>
        map(s("/"), fn _ -> 
          fn lhs, rhs ->
            lhs * rhs
          end
        end)
      )
    end)
  end

  def p do
    rule(fn ->
      map(s("(") ~>> e ~>> s(")"), fn result ->
        {{"(", v}, ")"} = result
        v
      end) <|>
      n
    end)
  end

  def n do
    map(regex(~r/[0-9]+/), fn v1 ->
      {v2, _} = Integer.parse(v1)
      v2
    end)
  end

  test "parser" do
    assert {:success, 21, ""} == e.("(1+2)*(3+4)")
  end
end
