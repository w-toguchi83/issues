# Elixir v1.9 から、mixプロジェクトで config/confix.exs は自動生成されなくなった.
# また Mix.Config は非推奨になった.代わりに Config モジュールを使用する.
# https://elixir-lang.org/blog/2019/06/24/elixir-v1-9-0-released/
# https://hexdocs.pm/elixir/master/Config.html
import Config

config :issues,
  github_url: "https://api.github.com"
