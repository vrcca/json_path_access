defmodule JsonPathAccess.Access do
  def slice(first, last, step) do
    slice(Range.new(first, last, step))
  end

  def slice(%Range{} = range) do
    fn op, data, next -> slice(op, data, range, next) end
  end

  defp slice(:get, data, range, next) do
    next.(Enum.slice(data, range))
  end

  defp slice(:get_and_update, data, %Range{first: first, last: last, step: _step} = range, next) do
    slice = Enum.slice(data, range)

    case next.(slice) do
      :pop ->
        {slice, data -- slice}

      {get, changes} ->
        begin = if first >= 0, do: 0, else: length(data)
        start = Enum.take(data, begin + first)
        end_list = Enum.drop(data, begin + last + 1)
        changes = start ++ changes ++ end_list
        {get, changes}
    end
  end
end
