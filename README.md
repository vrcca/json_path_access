# JsonPathAccess

This library converts JSONPath expressions into Access list. This is really useful when you want to use it with `get_in/2`, `drop_in/2`, etc.


## Example

Assuming we have this JSON:
```json
{
  "store": {
    "book": [
      {
        "category": "reference",
        "author": "Nigel Rees",
        "title": "Sayings of the Century",
        "price": 8.95
      },
      {
        "category": "fiction",
        "author": "Evelyn Waugh",
        "title": "Sword of Honour",
        "price": 12.99
      },
      {
        "category": "fiction",
        "author": "Herman Melville",
        "title": "Moby Dick",
        "isbn": "0-553-21311-3",
        "price": 8.99
      },
      {
        "category": "fiction",
        "author": "J. R. R. Tolkien",
        "title": "The Lord of the Rings",
        "isbn": "0-395-19395-8",
        "price": 22.99
      }
    ],
    "bicycle": {
      "color": "red",
      "price": 19.95
    }
  }
}

```

You could access some fields using JSONPath selectors:

```elixir
json_path = JsonPathAccess.to_access("$.store.bicycle.price")
get_in(json, json_path)

json_path = JsonPathAccess.to_access("$.store.book[1]['category']")
get_in(json, json_path)
```

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
- [x] Index Wildcard Selector
- [x] Array Slice Selector
  - Note: Currently there is no support for negative steps.
- [ ] Filter Selector
- [ ] Descendant Selector
- [ ] List Selector

