defmodule Issues.TableFormatter do

  import Enum, only: [
    each: 2, map: 2, map_join: 3, max: 1
  ]

  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths = widths_of(data_by_columns),
         format = format_for(column_widths)
    do
      puts_one_line_in_columns(headers, format)
      IO.puts(separator(column_widths))
      puts_in_columns(data_by_columns, format)
    end
  end

  def split_into_columns(rows, headers) do
    # for のネスト. コレクションのコレクションを作成する.
    # ここでは、リストのリストが作成される.
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  # 文字列はバイナリなので、 is_binary を使って判定している.
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def widths_of(data_by_columns) do
    # 各カラムの最大の長さのリストを返す.
    for data <- data_by_columns, do: data |> map(&String.length/1) |> max
  end

  def format_for(column_widths) do
    # Enum.map_join
    # https://hexdocs.pm/elixir/Enum.html#map_join/3
    # コレクションに関数を適用して結果を1つの文字列にして返す.
    map_join(column_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  def puts_in_columns(data_by_columns, format) do
    # List.zip はリストのリスト要素が3つ以上でも可能
    # ex: 
    # x = [[1,2,3], [:a, :b, :c], ["aaa", "bbb", "ccc"]]
    # List.zip(x) -> [{1, :a, "aaa"}, {2, :b, "bbb"}, {3, :c, "ccc"}]
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
    # elixirでの実装は扱っているデータの構造がどんなものになっているのか、かなり意識する必要がある.
  end

  def puts_one_line_in_columns(fields, format) do
    # Erlangモジュールの関数呼び出し.
    # format_for で作成した文字列は、 :io.format にわたすフォーマット文字列.
    :io.format(format, fields)
  end
end
