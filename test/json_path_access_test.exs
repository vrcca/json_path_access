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
end
