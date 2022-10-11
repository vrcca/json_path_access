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

  def combine(funs) do
    fn op, data, next -> combine(op, data, funs, next) end
  end

  defp combine(:get, data, funs, next) do
    Enum.map(funs, fn fun ->
      fun.(:get, data, next)
    end)
    |> next.()
  end

  defp combine(:get_and_update, data, funs, next) do
    pop = next.(hd(data)) == :pop
    next = if pop, do: &{&1, :pop}, else: next

    {gets, update} =
      Enum.reduce(funs, {[], data}, fn fun, {gets, update} ->
        {new_gets, new_update} = fun.(:get_and_update, update, next)
        {[new_gets | gets], new_update}
      end)

    update = if pop, do: Enum.reject(update, &(&1 == :pop)), else: update

    {:lists.reverse(gets), update}
  end
end
