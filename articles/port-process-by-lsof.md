---
title: "特定の port を使っている process を調べる"
emoji: "🏁"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["unix"]
published: true
---

# 特定の port を使っている process を調べる

``` bash
lsof -i :${PORT}
```

## 実行例

``` bash
$ lsof -i :8000
COMMAND  PID   USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
node    3023 tdrk18   23u  IPv6 0x1516d79f5df6f187      0t0  TCP *:irdmi (LISTEN)
```

実行されている command や PID がわかるので、それを使って必要なこと（process を kill するなど）をする。