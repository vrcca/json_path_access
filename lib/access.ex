defmodule JsonPathAccess.Access do
  @moduledoc false

  def combine(funs) do
    fn op, data, next_fun -> combine(op, data, funs, next_fun) end
  end

  defp combine(:get, data, funs, next_fun) do
    result = Enum.map(funs, fn fun -> fun.(:get, data, next_fun) end)
    next_fun.(result)
  end

  defp combine(:get_and_update, data, funs, next_fun) do
    pop = next_fun.(hd(data)) == :pop
    next_fun = if pop, do: fn data -> {data, :pop} end, else: next_fun

    {gets, update} =
      Enum.reduce(funs, {[], data}, fn fun, {gets, update} ->
        {new_gets, new_update} = fun.(:get_and_update, update, next_fun)
        {[new_gets | gets], new_update}
      end)

    update = if pop, do: Enum.reject(update, &(&1 == :pop)), else: update

    {Enum.reverse(gets), update}
  end
end
