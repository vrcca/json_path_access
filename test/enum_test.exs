defmodule JsonPathAccess.EnumTest do
  use ExUnit.Case, async: true

  describe "merge/3" do
    test "merge list into another using range" do
      assert ~w(a B c) == JsonPathAccess.Enum.merge(~w(a b c), ~w(B), 1..2//2)
      assert ~w(a B c) == JsonPathAccess.Enum.merge(~w(a b c), ~w(B), -2..-1)
      assert ~w(A b C) == JsonPathAccess.Enum.merge(~w(a b c), ~w(A C), -3..-1//2)
      assert ~w(a b c) == JsonPathAccess.Enum.merge(~w(a b c), ~w(), -3..-1//2)
      assert ~w(A B C) == JsonPathAccess.Enum.merge(~w(a b c), ~w(A B C), -3..-1)
      assert ~w(A B C) == JsonPathAccess.Enum.merge(~w(a b c), ~w(A B C), 0..2)
      assert [] == JsonPathAccess.Enum.merge([], ~w(A B C), 0..2)
    end
  end

  describe "drop_slice/2" do
    assert ~w(a c) == JsonPathAccess.Enum.drop_slice(~w(a b c), 1..2//2)
    assert ~w(a b c) == JsonPathAccess.Enum.drop_slice(~w(a b b c), 1..2//2)
    assert ~w(a) == JsonPathAccess.Enum.drop_slice(~w(a b c), -2..-1)
    assert ~w(b) == JsonPathAccess.Enum.drop_slice(~w(a b c), -3..-1//2)
    assert [] == JsonPathAccess.Enum.drop_slice(~w(a b c), -3..-1)
    assert [] == JsonPathAccess.Enum.drop_slice(~w(a b c), 0..2)
    assert ~w(a b c) == JsonPathAccess.Enum.drop_slice(~w(a b c), 3..4)
  end
end
