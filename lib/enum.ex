defmodule JsonPathAccess.Enum do
  def merge(data, changes, range) do
    begin = if(range.first >= 0, do: 0, else: length(data))

    {_index, acc, _current} =
      for element <- data, reduce: {0, [], changes} do
        {index, acc, changes} ->
          if changes != [] and (index - begin) in range do
            [head | tail] = changes
            {index + 1, [head | acc], tail}
          else
            {index + 1, [element | acc], changes}
          end
      end

    Enum.reverse(acc)
  end

  def drop_slice(data, range) do
    begin = if(range.first >= 0, do: 0, else: length(data))

    {_index, acc} =
      for element <- data, reduce: {0, []} do
        {index, acc} ->
          if (index - begin) in range do
            {index + 1, acc}
          else
            {index + 1, [element | acc]}
          end
      end

    Enum.reverse(acc)
  end
end
