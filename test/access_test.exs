defmodule JsonPathAccess.AccessTest do
  use ExUnit.Case, async: true

  alias JsonPathAccess.Access

  describe "slice/1" do
    test "retrieves a range from the start of the list" do
      list = ["a", "b", "c", "d", "e", "f", "g"]
      assert ["b", "c"] == get_in(list, [Access.slice(1..2)])
    end

    test "retrieves a range from the end of the list" do
      list = ["a", "b", "c", "d", "e", "f", "g"]
      assert ["f", "g"] == get_in(list, [Access.slice(-2..-1)])
    end

    test "drops a range from the start of the list" do
      list = ["a", "b", "c", "d", "e", "f", "g"]
      assert {["b", "c"], ["a", "d", "e", "f", "g"]} == pop_in(list, [Access.slice(1..2)])
    end

    test "drops a range from the end of the list" do
      list = ["a", "b", "c", "d", "e", "f", "g"]
      assert {["f", "g"], ["a", "b", "c", "d", "e"]} == pop_in(list, [Access.slice(-2..-1)])
    end

    test "updates range from the start of the list" do
      list = ["a", "b", "c", "d", "e", "f", "g"]

      assert ["A", "b", "c", "d", "e", "f", "g"] ==
               update_in(list, [Access.slice(0..0)], &upcase_items/1)

      assert ["a", "B", "C", "d", "e", "f", "g"] ==
               update_in(list, [Access.slice(1..2)], &upcase_items/1)
    end

    test "updates range from the end of the list" do
      list = ["a", "b", "c", "d", "e", "f", "g"]

      assert ["a", "b", "c", "d", "e", "F", "G"] ==
               update_in(list, [Access.slice(-2..-1)], &upcase_items/1)

      assert ["A", "B", "c", "d", "e", "f", "g"] ==
               update_in(list, [Access.slice(-7..-6)], &upcase_items/1)
    end
  end

  defp upcase_items(items), do: Enum.map(items, &String.upcase/1)
end
