# Issues

[書籍『プログラミング Elixir』](https://www。amazon。co。jp/dp/B01KFCXP04/ref=dp-kindle-redirect?_encoding=UTF8&btkr=1) の "第13章 プロジェクトを構成する" に記載されているプロジェクトの実装。

書籍のElixirは `v1。2` だが、2020年08月時点で本家Elixirは `v1。10` になっている。

そのため、書籍に記載されているまま実装しても動作しない箇所がある。 

今回は、 `v1。10` で動作するように適宜、修正・改変を行い実装した。

また自分向けに理解したコト、感想などをコメントで追加している。

書籍は、そのまま実装しても動作しないので写経として使えない。新しい本の出版を期待したい。 (内容的には勉強になることは多いけど)


```
warning: variable "split_with_three_columns" does not exist and is being expanded to "split_with_three_columns()", please use parentheses to remove the ambiguity or change the variable name
```

この `変数だか関数だか曖昧だぞ` の警告に戸惑った。 アリティが `0` の関数は、定数とか変数という見方をしても動作的に問題なし! みたいな Rubyライクな構文もElixirの売りだと勝手に思っていたから。 どこかのバージョンで変わったのかなー。

とりあえず、「関数だよ」って教えるために `()` を付けて解決しました。

兎にも角にも、久しぶりに Elixir 書いて楽しかった! [2020/08/01]
