defmodule CliTest do
  # use は指定したモジュールに定義されている __using__ マクロ(or関数)を呼び出す.
  # __using__ マクロ(or関数)の中で、所謂「魔法」が実行されて、モジュール内への関数導入などの作用を起こす.
  use ExUnit.Case

  # https://github.com/elixir-lang/elixir/blob/master/lib/ex_unit/lib/ex_unit/case.ex
  # ExUnit.Case の __using__ の実行によって
  # import ExUnit.DocTest が実行されて、 `doctest` マクロが呼び出せるようになっている.
  doctest Issues

  # import は名前を完全修飾せずに関数を呼び出せるようにするための機能.
  import Issues.CLI, only: [ parse_args: 1 ]

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
end
