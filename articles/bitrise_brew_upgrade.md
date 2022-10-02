---
title: "Bitrise で brew upgrade できないとき"
emoji: "🍺"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["bitrise", "homebrew"]
published: true
---

# Bitrise で `brew upgrade <formula>` をしたい

ここでは formula として `mint` を例に扱う。
https://github.com/yonaskolb/Mint

2022/10/02 時点で、Bitrise のマシン (Intel, Xcode 14.0.x) にインストールされているバージョンは 0.17.1。
https://github.com/bitrise-io/bitrise.io/blob/31d00afebe2f585c32a5e6f0af0ad09069e212d8/system_reports/MACOS/INTEL/osx-xcode-14.0.x.log#L190

2022/09/29 に 0.17.2 がリリースされている。
https://github.com/yonaskolb/Mint/releases/tag/0.17.2

0.17.2 に含まれている変更を使いたいので、最新版にアップグレードをしたい。
以下のコマンドを実行する。
```sh
brew update
brew upgrade mint
```

しかし、その結果は以下のようになり、 0.17.2 にアップグレードされず 0.17.1 が使われ続ける。
```Bitrise log
+ brew update
==> Homebrew is run entirely by unpaid volunteers. Please consider donating:
  https://github.com/Homebrew/brew#donations
Updated 3 taps (homebrew/cask-versions, dart-lang/dart and danger/tap).
==> New Casks
temurin18
==> Outdated Formulae
danger-js
dart
You have 2 outdated formulae installed.
You can upgrade them with brew upgrade
or list them with brew outdated.
+ brew upgrade mint
Warning: mint 0.17.1 already installed
```

# 原因

`homebrew-core` の remote origin が GitHub ではなく、別の mirror に向いていたためであった。

`brew doctor` の結果から、そのようになっていることがわかる。
```sh
brew doctor
```

```
Please note that these warnings are just used to help the Homebrew maintainers
with debugging if you file an issue. If everything you use Homebrew for is
working fine: please don't worry or file an issue; just ignore this. Thanks!

Warning: Suspicious https://github.com/Homebrew/homebrew-core git origin remote found.
The current git origin is:
  /Users/vagrant/mirrors/github.com/bitrise-io/homebrew-core

With a non-standard origin, Homebrew won't update properly.
You can solve this by setting the origin remote:
  git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core" remote set-url origin https://github.com/Homebrew/homebrew-core
...
```

# 対策

`brew doctor` に書かれているように、 remote origin を GitHub に向け、 `brew update`, `brew upgrade` をすることで最新版にアップグレードできる。

```sh
git -C "/usr/local/Homebrew/Library/Taps/homebrew/homebrew-core" remote set-url origin https://github.com/Homebrew/homebrew-core
brew update
brew upgrade
```

以下が実行結果（例と関係のない部分は省略している）。
```
+ git -C /usr/local/Homebrew/Library/Taps/homebrew/homebrew-core remote set-url origin https://github.com/Homebrew/homebrew-core
+ brew update
==> Homebrew is run entirely by unpaid volunteers. Please consider donating:
  https://github.com/Homebrew/brew#donations
Updated 4 taps (homebrew/cask-versions, homebrew/core, dart-lang/dart and danger/tap).
==> New Formulae
...
==> Outdated Formulae
...
mint
...
You have 40 outdated formulae installed.
You can upgrade them with brew upgrade
or list them with brew outdated.
+ brew upgrade mint
==> Upgrading 1 outdated package:
mint 0.17.1 -> 0.17.2
==> Downloading https://ghcr.io/v2/homebrew/core/mint/manifests/0.17.2
==> Downloading https://ghcr.io/v2/homebrew/core/mint/blobs/sha256:26c136026b22e8c13ae136d984af578ef2d32ae189216da6761b1435428cb4a3
==> Downloading from https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:26c136026b22e8c13ae136d984af578ef2d32ae189216da6761b1435428cb4a3?se=2022-10-02T13%3A40%3A00Z&sig=O47kuyp1K%2FfowwfmocIutjY65whc%2F06kbHw1%2B9CgB1k%3D&sp=r&spr=https&sr=b&sv=2019-12-12
==> Upgrading mint
  0.17.1 -> 0.17.2 
==> Pouring mint--0.17.2.monterey.bottle.tar.gz
🍺  /usr/local/Cellar/mint/0.17.2: 6 files, 1.5MB
```