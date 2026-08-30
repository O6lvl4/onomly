# name-check

プロダクト/プロジェクト名候補の**デューデリジェンス調査**をする [Claude Code](https://claude.com/claude-code) スキル。名前を渡すと、パッケージレジストリ・ドメイン・GitHub の空き、既存プロダクト・商標の衝突、多言語での意味、検索性/LLM 識別性を定型手順で調べ、**判定付きレポート**を返す。

```
/name-check Heartwood
```

```
結論: 🟡 要注意 — 一般名詞で主要な取得先が総取られ
┌───────────┬─────────────┐
│ GitHub    │ ❌ taken     │
│ npm       │ ❌ taken     │
│ crates.io │ ❌ taken     │
│ PyPI      │ ✅ 空き       │
│ .com/.ai… │ ❌ 全部登録済 │
└───────────┴─────────────┘
既存プロダクト: AWS Lambda 監視ツール heartwood ほか多数 …
```

## インストール

スキルディレクトリに clone するだけ:

```sh
git clone https://github.com/O6lvl4/name-check ~/.claude/skills/name-check
```

Claude Code を再起動すると `/name-check` が使えるようになる。

## 使い方

```sh
/name-check <名前>              # 1 個
/name-check Foo Bar Baz         # 複数まとめて (最後に比較表)
```

引数なしで呼ぶと候補名を聞き返す。

## 何を調べるか

1. **機械チェック** (`check.sh`) — npm / crates.io / PyPI / RubyGems / Homebrew / GitHub ユーザー名 / ドメイン (`.com .ai .io .dev .org`、RDAP→whois フォールバック)。`AVAILABLE` / `taken` / `registered` で判定
2. **既存プロダクト・商標** — 英語・日本語で Web 検索し、同名プロダクト、一般名詞化、有名 CS 用語との衝突を拾う
3. **多言語・文化** — 主要言語 (英西仏独中日) でのネガティブな意味・スラング、発音のしやすさ、綴りの一意性
4. **検索性・LLM 識別性** — 検索結果を独占できるか、AI が別プロダクトと混同しないか、商標としての識別力

## レポート形式

候補ごとに「**結論 (推奨 / 要注意 / 避けるべき)**」を先頭に、取得可能性の表、既存プロダクトの衝突（リンク付き）、商標所見、検索性評価。複数候補なら最後に比較表と推奨順位。

## 依存

`curl` / `whois` / `python3` / `bash`（macOS・Linux で動作）。

## 制限

- 商標 DB の正式検索（J-PlatPat / USPTO / EUIPO）は自動化していない。リスクが見えた候補は正式な商標調査（弁理士）を推奨
- GitHub API は未認証だと 60 回/時。大量候補を一度に調べると `unknown` が出得る
- **簡易調査であり法的助言ではない**

## License

MIT
