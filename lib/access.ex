defmodule JsonPathAccess.Access do
  def slice(first, last, step) do
    slice(Range.new(first, last, step))
  end

  def slice(%Range{} = range) do
    fn op, data, next -> slice(op, data, range, next) end
  end

  defp slice(:get, data, %Range{} = range, next) do
    next.(Enum.slice(data, range))
  end

  defp slice(:get_and_update, data, range, next) do
    slice = Enum.slice(data, range)

    case next.(slice) do
      :pop ->
        {slice, JsonPathAccess.Enum.drop_slice(data, range)}

      {get, changes} ->
        changes = JsonPathAccess.Enum.merge(data, changes, range)
        {get, changes}
    end
  end

  def combine(functions) do
    fn op, data, next -> combine(op, data, functions, next) end
  end

  defp combine(:get, data, functions, next) do
    Enum.map(functions, fn function ->
      function.(:get, data, next)
    end)
    |> next.()
  end

  defp combine(:get_and_update, _data, _functions, _next) do
    raise "get_and_update not implemented for combined Access functions."
  end
end
