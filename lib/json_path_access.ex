defmodule JsonPathAccess do
  @moduledoc """
  This module converts a JsonPath expression into a list of Access. This is useful
  when you want to use it with `get_in`, `drop_in`, etc.

  You can find the specification here: https://www.ietf.org/archive/id/draft-ietf-jsonpath-base-05.html
  """
  def to_access(exp) do
    {:ok, matches, "", _map, _tuple, _integer} = JsonPathAccess.Parser.parse(exp)

    matches
  end
end
