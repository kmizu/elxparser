defmodule ElxParser do
  def s(prefix) do
    fn input ->
      if String.starts_with?(input, prefix) do
        input_len = String.length(input)
        prefix_len = String.length(prefix)
        {:success, String.slice(input, 0..(prefix_len - 1)), String.slice(input, (prefix_len..(input_len - 1)))}
      else
        {:failure, input}
      end
    end
  end

  def alt(x, y) do
    fn input ->
      result = x.(input) 
      case result do
        {:failure, _} -> y.(input)
        otherwise -> otherwise
      end
    end
  end

  def seq(x, y) do
    fn input ->
      case x.(input) do
        {:success, v1, next1} ->
          case y.(next1) do
            {:success, v2, next2} -> {:success, {v1, v2}, next2}
            otherwise -> otherwise
          end
        otherwise -> otherwise
      end
    end
  end

  def loop(parser, rest, results) do
    case parser.(rest) do
      {:success, v, next} -> loop(parser, next, [v|results]) 
      {:failure, next} -> {:success, results, next}
    end
  end

  def rep(x) do
    fn input ->
      {:success, values, next} = loop(x, input, [])
      {:success, List.reverse(values), next}
    end
  end

  def flat_map(parser, f) do
    fn input ->
      case parser.(input) do
        {:failure, _} -> {:failure, input}
        {:success, v, next} -> (f.(v)).(next)
      end
    end
  end

  def map(parser, f) do
    fn input ->
      case parser.(input) do
        {:success, v, next} -> {:success, f.(v), next}
        otherwise -> otherwise
      end
    end
  end

  def chainl(p, q) do
    map(
      seq(p, rep(seq(q, p))), 
      fn values ->
        [x|xs] = values
        List.foldl(
          xs,
          x,
          fn (r, e) ->
            {f, a} = e
            f.(r, a)
          end
        )
      end
    )
  end
end
