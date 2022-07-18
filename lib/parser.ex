defmodule JsonPathAccess.Parser do
  import NimbleParsec

  root = string("$")

  name = ascii_string([?A..?Z, ?a..?z, ?_], min: 1)

  name_first = ascii_string([?A..?Z, ?a..?z, ?_], min: 1)
  name_char = ascii_string([?A..?Z, ?a..?z, ?0..?9], min: 1)

  dot_member_name =
    name_first
    |> optional(name_char)
    |> reduce({Enum, :join, []})

  dot_selector =
    ignore(string("."))
    |> concat(dot_member_name)

  dot_wildcard_selector =
    ignore(string(".*"))
    |> post_traverse({:all, []})

  wildcard_index_selector =
    ignore(string("[*]"))
    |> post_traverse({:all, []})

  wildcard_selector = choice([wildcard_index_selector, dot_wildcard_selector])

  object_name_selector =
    ignore(string("['"))
    |> concat(name)
    |> ignore(string("']"))

  array_index_selector =
    ignore(string("["))
    |> optional(string("-"))
    |> integer(min: 1)
    |> ignore(string("]"))
    |> reduce({Enum, :join, []})
    |> map({String, :to_integer, []})
    |> map({Access, :at, []})

  index_selector = choice([object_name_selector, array_index_selector])

  filters =
    ignore(string("[?("))
    |> utf8_string([], min: 1)
    |> ignore(string(")]"))

  json_path =
    ignore(root)
    |> concat(repeat(choice([dot_selector, wildcard_selector, index_selector, filters])))

  defparsec(:parse, json_path, debug: true)

  defp all(_rest, _args = [], context, _line, _offset) do
    {[Access.all()], context}
  end
end
