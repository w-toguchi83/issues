defmodule Issues.CLI do

  # モジュール属性. 定数として使える.
  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
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

  def process(:help) do
    IO.puts """
    usage: issues <user> <project> [ count | #{@default_count} ]
    """
    System.halt(0)
  end

  def process({user, project, _count}) do
    # 関数が戻り値をタプルで返すことによって、
    # パイプ処理がやりやすくなっている、と思った.
    Issues.GithubIssues.fetch(user.project)
    |> decode_response
    |> convert_to_list_of_maps
  end

  # 関数のボディ(do ... endブロック) は実のところ、キーワードリストである.
  # だからこの1行書きの関数定義ができる.
  def decode_response({ :ok, body }), do: body

  def decode_response({ :error, error }) do
    # https://hexdocs.pm/elixir/List.html#keyfind/4
    {_, message} = List.keyfind(error, "message", 0)
    IO.puts "Error fetching from Github: #{message}"
    System.halt(2)
  end

  def convert_to_list_of_maps(list) do
    # &演算子で、インラインで `Enum.into` を関数化し、Enum.mapにわたす関数にしている.
    # `Enum.into` は列挙型をコレクション型に変換できる関数.
    # https://hexdocs.pm/elixir/Enum.html#into/2
    # `list` は、リストのリストで内側のリストがタプルのリストになっている.
    # このタプルのリストを `Enum.into` で、マップに変換している.
    list
    |> Enum.map(&Enum.into(&1, Map.new))
  end

end
