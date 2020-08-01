# Elixir v1.9 から、mixプロジェクトで config/confix.exs は自動生成されなくなった.
# また Mix.Config は非推奨になった.代わりに Config モジュールを使用する.
# https://elixir-lang.org/blog/2019/06/24/elixir-v1-9-0-released/
# https://hexdocs.pm/elixir/master/Config.html
import Config

config :issues,
  github_url: "https://api.github.com"

# loggerの設定方法が書籍と変わっている箇所.
config :logger,
  backends: [:console],
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]
