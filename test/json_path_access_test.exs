defmodule JsonPathAccessTest do
  use ExUnit.Case, async: true
  doctest JsonPathAccess

  alias JsonPathAccess

  test "converts dot notation" do
    assert ["property", "nested"] == JsonPathAccess.to_access("$.property.nested")
    assert ["Property", "nest_Ed"] == JsonPathAccess.to_access("$.Property.nest_Ed")
    assert ["number1"] == JsonPathAccess.to_access("$.number1")
    assert_raise MatchError, fn -> JsonPathAccess.to_access("$.1number") end
  end

  test "converts dot wildcard notation" do
    assert ["property", Access.all()] == JsonPathAccess.to_access("$.property.*")
    assert ["property", Access.all()] == JsonPathAccess.to_access("$.property[*]")
  end

  test "converts bracket notation" do
    assert ["property", "nested"] == JsonPathAccess.to_access("$['property']['nested']")
    assert ["Property", "neSt_ed"] == JsonPathAccess.to_access("$['Property']['neSt_ed']")
    assert ["Pro perty", "neSt.ed"] == JsonPathAccess.to_access("$['Pro perty']['neSt.ed']")
    assert ["Pro perty", "neSt.ed"] == JsonPathAccess.to_access("$[\"Pro perty\"][\"neSt.ed\"]")
  end

  test "converts a mix of dot and bracket notation" do
    assert ["property", "nested", "another"] ==
             JsonPathAccess.to_access("$['property'].nested['another']")

    assert ["Property", "Nested", "ano_Ther"] ==
             JsonPathAccess.to_access("$['Property'].Nested['ano_Ther']")
  end

  test "converts array index" do
    assert ["property", Access.at(0)] == JsonPathAccess.to_access("$['property'][0]")
    assert ["property", Access.at(1)] == JsonPathAccess.to_access("$.property[1]")
    assert ["last", Access.at(-1)] == JsonPathAccess.to_access("$.last[-1]")
  end

  test "converts array slices" do
    assert [JsonPathAccess.Access.slice(1, 2, 1)] == JsonPathAccess.to_access("$[1:3]")
    assert [JsonPathAccess.Access.slice(1, 4, 1)] == JsonPathAccess.to_access("$[1:5:1]")
    assert [JsonPathAccess.Access.slice(5, 1, -1)] == JsonPathAccess.to_access("$[5:1:-1]")
  end

  test "converts list selectors" do
    list = ~w(a b c d e f g)
    assert ~w(b d b g) == get_in(list, JsonPathAccess.to_access("$[1, 3, 1, -1]"))
    assert ["b", ["b", "c", "d"], "f"] == get_in(list, JsonPathAccess.to_access("$[1, 1:4, -2]"))
  end
end
