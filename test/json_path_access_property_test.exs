defmodule JsonPathAccessPropertyTest do
  use ExUnit.Case
  use ExUnitProperties

  property "passing a dot selector returns the list of fields" do
    check all fields <- list_of(dot_member_name(), min_length: 1) do
      dotted_fields = Enum.join(fields, ".")
      path = "$.#{dotted_fields}"
      assert fields == JsonPathAccess.to_access(path)
    end
  end

  # dot-selector    = "." dot-member-name
  # dot-member-name = name-first *name-char
  # name-first      =
  #                       ALPHA /
  #                       "_"   /           ; _
  #                       %x80-10FFFF       ; any non-ASCII Unicode character
  # name-char = DIGIT / name-first

  # DIGIT           =  %x30-39              ; 0-9
  # ALPHA           =  %x41-5A / %x61-7A    ; A-Z / a-z
  defp dot_member_name do
    gen all name_first <- name_first(),
            name_first != "",
            name_char <- name_char() do
      "#{name_first}#{name_char}"
    end
  end

  defp name_first do
    one_of([alpha(), constant("_"), unicode()])
  end

  defp name_char do
    one_of([digit(), name_first()])
  end

  defp alpha do
    string([?a..?z, ?A..?Z])
  end

  defp unicode do
    string([0x80..0x9FFF, 0x10000..0x10FFFF])
  end

  defp digit do
    string(?0..?9)
  end
end
