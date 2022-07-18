# JsonPathAccess

This library converts JSONPath expressions into Access list. This is really useful when you want to use it with `get_in/2`, `drop_in/2`, etc. 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `json_path_access` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:json_path_access, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/json_path_access>.

## TODO

This library attempts to implement this version of the spec: https://www.ietf.org/archive/id/draft-ietf-jsonpath-base-05.html

- [x] Root Selector
- [x] Dot Selector
- [x] Dot Wildcard Selector
- [x] Index Selector
- [ ] Index Wildcard Selector
- [ ] Array Slice Selector
- [ ] Descendant Selector
- [ ] Filter Selector
- [ ] List Selector

