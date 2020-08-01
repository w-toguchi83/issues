defmodule Issues.GithubIssues do
  @user_agent [ {"User-agent", "Elixir hello@example.com"} ]

  def fetch(user, project) do
    # HTTPoisonはライブラリだがアプリケーションでもあり、
    # `HTTPoison.start` を実行してプロセスを生成しておく必要がある.
    # 書籍『プログラミング Elixir』では、インラインで `HTTPoison.start` をせずに
    # mix.exs の `application` 関数で `:httpoison` を指定することで、プロジェクト起動時に
    # HTTPoisonアプリケーションも起動する設定を行なっているが、Elixir v1.4 から不要になった.
    #
    # 参考: https://elixir-lang.org/blog/2017/01/05/elixir-v1-4-0-released/
    # ---
    # Mix will automatically build your application list based on your dependencies.
    # ---
    # つまり、depsに定義した依存ライブラリ(アプリケーション)は自動的にmixの管理する
    # アプリケーションのリストに追加される.
    # よって、インラインでのstart起動も、mix.exsへの追記も不要になっている.
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  @github_url Application.fetch_env!(:issues, :github_url)
  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  # %{...} はマップ
  # 関数のパターンマッチによって処理を振り分けている.
  def handle_response({ :ok, %{status_code: 200, body: body}}) do
    # HTTTPのレスポンスを単純なタプルにして返すだけの関数.
    { :ok, Poison.Parser.parse!(body) }
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    { :error, Poison.Parser.parse!!(body) }
  end
end
