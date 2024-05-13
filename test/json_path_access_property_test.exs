defmodule JsonPathAccessPropertyTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  property "passing a dot selector returns the list of fields" do
    check all fields <- list_of(dot_selector(), min_length: 1) do
      path = "$#{Enum.join(fields)}"
      expected_fields = Enum.map(fields, fn "." <> name -> name end)
      assert expected_fields == JsonPathAccess.to_access(path)
    end
  end

  property "all dot wildcards selectors are returned as Access.all/1" do
    check all fields <- list_of(one_of([dot_selector(), dot_wild_selector()]), min_length: 1) do
      path = "$#{Enum.join(fields)}"

      expected_fields =
        Enum.map(fields, fn
          ".*" -> Access.all()
          "." <> name -> name
        end)

      assert expected_fields == JsonPathAccess.to_access(path)
    end
  end

  property "element index selector is returned as Access.at/1" do
    check all fields <- list_of(one_of([dot_selector(), index_selector()]), min_length: 1) do
      path = "$#{Enum.join(fields)}"

      expected_fields =
        Enum.map(fields, fn
          "[" <> _rest = index_str ->
            to_index_access(index_str)

          "." <> name ->
            name
        end)

      assert expected_fields == JsonPathAccess.to_access(path)
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
  defp dot_selector do
    gen all name_first <- name_first(),
            name_first != "",
            name_char <- name_char() do
      ".#{name_first}#{name_char}"
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

  # dot-wild-selector    = "." "*"            ;  dot followed by asterisk
  defp dot_wild_selector do
    constant(".*")
  end

  # index-selector      = "[" S (quoted-member-name / element-index) S "]"
  defp index_selector do
    gen all index <- one_of([integer()]) do
      "[#{index}]"
    end
  end

  @element_index_re ~r/\[(?<index>[-+]?\d*)\]/
  defp to_index_access(text) do
    %{"index" => index} = Regex.named_captures(@element_index_re, text)

    index
    |> String.to_integer()
    |> Access.at()
  end
end
