defmodule JsonPathAccess.Access do
  @moduledoc false

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
