defmodule Issues.CLI do

  # モジュール属性. 定数として使える.
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def run(argv) do
    parse_args(argv)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.
  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    # swiches, aliases に指定しているリストは、キーワードリストである事を意識すること.
    # https://hexdocs.pm/elixir/OptionParser.html
    # 3タプルを返す.
    parse = OptionParser.parse(argv, switches: [ help: :boolean], aliases: [ h: :help ])

    # case式はパターンマッチで条件分岐ができる.
    # cond式との違いを意識せよ.
    case parse do
      { [ help: true ], _, _ } -> :help
      { _, [ user, project, count ], _ } -> { user, project, String.to_integer(count) }
      { _, [ user, project], _ } -> { user, project, @default_count }
      _ -> :help
    end
  end
end