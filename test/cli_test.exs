defmodule CliTest do
  # use は指定したモジュールに定義されている __using__ マクロ(or関数)を呼び出す.
  # __using__ マクロ(or関数)の中で、所謂「魔法」が実行されて、モジュール内への関数導入などの作用を起こす.
  use ExUnit.Case

  # https://github.com/elixir-lang/elixir/blob/master/lib/ex_unit/lib/ex_unit/case.ex
  # ExUnit.Case の __using__ の実行によって
  # import ExUnit.DocTest が実行されて、 `doctest` マクロが呼び出せるようになっている.
  doctest Issues

  # import は名前を完全修飾せずに関数を呼び出せるようにするための機能.
  import Issues.CLI, only: [
    parse_args: 1,
    sort_into_ascending_order: 1,
    convert_to_list_of_maps: 1
  ]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == { "user", "project", 99 }
  end

  test "count is defaulted if two values given" do
    assert parse_args(["user", "project"]) == { "user", "project", 4 }
  end

  test "sort ascending orders the correct way" do
    # このテストのわかりにくさは、"created_at" という日時の並び替えをテストしたいのに
    # "c", "a", "b" という文字列を "created_at" として作成しているところ.
    # ただElixirは全ての型について大小比較が可能なので、テストとして成り立つ、という見方ができる.
    result = sort_into_ascending_order(fake_created_at_list(["c", "a", "b"]))
    # result(fake_created_at_list)の戻り値はマップ. for でマップの "created_at" の値を取り出している.
    issues = for issue <- result, do: issue["created_at"]

    # ~w は、シジル。文字列のリストを生成する.
    assert issues == ~w{a b c}
  end

  # テストのためのヘルパー関数を定義できる.(まあ、モジュールだから当然か)
  defp fake_created_at_list(values) do
    #data = for value <- values, do: [ { "created_at", value} , { "other_data", "xxx"} ]
    #convert_to_list_of_maps data

    # [ "created_at": value, "other_data": "xxx" ]
    # というように {} を省略してキーワードリストで書くとwarningが出る.
    # キーワードリストの制約として、キーはアトムである必要があるため.

    # パイプ演算子で上のコードを次のように書き換えもできる(が、わかりにくい???)
    (for value <- values, do: [ { "created_at", value },  { "other_data", "xxx" } ])
    |> convert_to_list_of_maps
  end
end
