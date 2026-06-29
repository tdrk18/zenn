---
title: "Danger の実行を少し早くする tips"
emoji: "⚡"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["danger", "ruby", "ci"]
published: true
---

## 概要

Danger は実行時に内部で `git fetch` を行います。事前に base ブランチと head ブランチを fetch しておくことで、この内部 fetch をスキップさせることができます。リポジトリの履歴が大きいほど（コミット数が多い、過去にバイナリが含まれていたなどの歴史的経緯がある）効果が大きいです。

## Danger の内部 fetch について

Danger は `setup_danger_branches` の中で、PR の base/head コミットがローカルに存在するかを確認します。存在しない場合、[`ensure_commitish_exists_on_branch!`](https://github.com/danger/danger/blob/master/lib/danger/scm_source/git_repo.rb) が呼ばれ、コミットが見つかるまで depth を増やしながら `git fetch` を繰り返します。

```ruby
# lib/danger/scm_source/git_repo.rb
def ensure_commitish_exists_on_branch!(branch, commitish)
  return if commit_exists?(commitish)

  depth = 0
  success =
    (3..6).any? do |factor|
      depth += Math.exp(factor).to_i

      git_fetch_branch_to_depth(branch, depth)  # depth を増やしながら fetch を繰り返す
      commit_exists?(commitish)
    end
  # ...
end
```

Git fetch に時間がかかるリポジトリの場合、この内部 fetch がボトルネックになります。

## 解決策

CI の設定で、Danger を実行する前に明示的に base/head ブランチを fetch しておきます。すでにコミットがローカルに存在する場合、`ensure_commitish_exists_on_branch!` は fetch をスキップするため、fetch にかかる余計な時間を省略できます。

## 設定例

### GitHub Actions

GitHub Actions では `GITHUB_BASE_REF` / `GITHUB_HEAD_REF` に base/head のブランチ名が入っています。

```yaml
- name: Fetch branches for Danger
  run: git fetch origin $GITHUB_BASE_REF $GITHUB_HEAD_REF

- name: Run Danger
  run: bundle exec danger
```

### Bitrise

Bitrise では `BITRISEIO_GIT_BRANCH_DEST` / `BITRISE_GIT_BRANCH` に base/head のブランチ名が入っています。

```yaml
- script:
    title: Fetch branches for Danger
    inputs:
      - content: |
          git fetch origin $BITRISEIO_GIT_BRANCH_DEST $BITRISE_GIT_BRANCH
- script:
    title: Run Danger
    inputs:
      - content: |
          bundle exec danger
```

## GitHub Actions 向け action を公開しました

この tips を GitHub Actions で手軽に利用できるよう、[danger-ruby-action](https://github.com/marketplace/actions/danger-ruby-action) として Marketplace に公開しました。Ruby のセットアップから事前 fetch・Danger の実行までをまとめて行います。

```yaml
- uses: actions/checkout@v7
- uses: tdrk18/danger-action@v1
```

## まとめ

シンプルな 1 行の追加ですが、Git fetch に時間がかかるリポジトリでは CI の実行時間を大幅に短縮できます。実際に適用して Danger の実行時間が約 6 分から約 1 分に短縮された例もあります。
