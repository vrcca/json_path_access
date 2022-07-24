defmodule JsonPathAccess.AccessTest do
  use ExUnit.Case, async: true

  alias JsonPathAccess.Access

  describe "slice/1" do
    test "retrieves a range from the start of the list" do
      list = ~w(a b c d e f g)
      assert ~w(b c) == get_in(list, [Access.slice(1..2)])
    end

    test "retrieves a range from the end of the list" do
      list = ~w(a b c d e f g)
      assert ~w(f g) == get_in(list, [Access.slice(-2..-1)])
    end

    test "retrieves a range with steps" do
      list = ~w(a b c d e f g)
      assert ~w(a c) == get_in(list, [Access.slice(0..2//2)])
      assert ~w(b e) == get_in(list, [Access.slice(1..4//3)])
      assert ~w(b) == get_in(list, [Access.slice(1..2//3)])
      assert ~w(a c e g) == get_in(list, [Access.slice(0..6//2)])
    end

    test "drops a range from the start of the list" do
      list = ~w(a b c d e f g)
      assert {~w(b c), ~w(a d e f g)} == pop_in(list, [Access.slice(1..2)])
    end

    test "drops a range from the end of the list" do
      list = ~w(a b c d e f g)
      assert {~w(f g), ~w(a b c d e)} == pop_in(list, [Access.slice(-2..-1)])
    end

    test "drops a range with steps" do
      list = ~w(a b c d e f g)
      assert {~w(a c e), ~w(b d f g)} == pop_in(list, [Access.slice(0..4//2)])
      assert {~w(b), ~w(a c d e f g)} == pop_in(list, [Access.slice(1..2//2)])
    end

    test "updates range from the start of the list" do
      list = ~w(a b c d e f g)
      assert ~w(A b c d e f g) == update_in(list, [Access.slice(0..0)], &upcase_items/1)
      assert ~w(a B C d e f g) == update_in(list, [Access.slice(1..2)], &upcase_items/1)
    end

    test "updates range from the end of the list" do
      list = ~w(a b c d e f g)
      assert ~w(a b c d e F G) == update_in(list, [Access.slice(-2..-1)], &upcase_items/1)
      assert ~w(A B c d e f g) == update_in(list, [Access.slice(-7..-6)], &upcase_items/1)
    end

    test "updates  a range with steps" do
      list = ~w(a b c d e f g)
      assert ~w(A b C d E f g) == update_in(list, [Access.slice(0..4//2)], &upcase_items/1)
    end
  end

  describe "merge/3" do
    test "merge list into another using range" do
      list = ~w(a b c)
      another_list = ~w(B)
      range = 1..2//2
      assert ~w(a B c) == Access.merge(list, another_list, range)
    end
  end

  defp upcase_items(items), do: Enum.map(items, &String.upcase/1)
end
