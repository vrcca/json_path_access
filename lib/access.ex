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
end
