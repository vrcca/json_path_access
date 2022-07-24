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
        # TODO: respect indexes from range
        {slice, data -- slice}

      {get, changes} ->
        changes = merge(data, changes, range)

        {get, changes}
    end
  end

  def merge(data, changes, range) do
    begin = if(range.first >= 0, do: 0, else: length(data))

    {_index, acc, _current} =
      for element <- data, reduce: {0, [], changes} do
        {index, acc, changes} ->
          if (index - begin) in range do
            [head | tail] = changes
            {index + 1, [head | acc], tail}
          else
            {index + 1, [element | acc], changes}
          end
      end

    Enum.reverse(acc)
  end
end
