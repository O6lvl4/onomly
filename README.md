<h1 align="center">onomly</h1>

<p align="center"><em>名前を、出す前に検分する。</em></p>

<p align="center">
プロダクト/プロジェクト名候補の<strong>デューデリジェンス調査</strong>をする
<a href="https://claude.com/claude-code">Claude Code</a> スキル。<br>
レジストリ・ドメイン・GitHub の空き、既存プロダクト・商標の衝突、多言語での意味、
検索性/LLM 識別性を定型で調べ、<strong>判定付きレポート</strong>を返す。
</p>

---

> [!NOTE]
> **`onomly` という名前自体、このツールで選んだ。** ギリシャ語 *onoma*(名前) → *onomastics*(名前学) から。
> 自分自身の検査をほぼ完全に通過している ↓

```text
$ onomly onomly
=== onomly ===
npm ✅  crates.io ✅  RubyGems ✅  Homebrew ✅  GitHub ✅
.com ✅  .ai ✅  .io ✅  .dev ✅  .org ✅
PyPI だけ taken
→ 推奨: 全レジストリ・全ドメインでクリア
```

## Install

スキルディレクトリに clone するだけ。

```sh
git clone https://github.com/O6lvl4/onomly ~/.claude/skills/onomly
```

Claude Code を再起動すると `/onomly` が使える。

## Usage

```sh
/onomly Heartwood            # 1 個
/onomly Foo Bar Baz          # 複数まとめて (最後に比較表)
```

引数なしなら候補名を聞き返す。

## What it checks

| # | 観点 | 中身 |
|---|------|------|
| 1 | **機械チェック** (`check.almd`) | npm / crates.io / PyPI / RubyGems / Homebrew / GitHub / ドメイン(`.com .ai .io .dev .org`、権威 RDAP→whois) |
| 2 | **既存プロダクト・商標** | 英日で Web 検索。同名プロダクト、一般名詞化、有名 CS 用語との衝突 |
| 3 | **多言語・文化** | 英西仏独中日でのネガティブな意味・スラング、発音・綴りの一意性 |
| 4 | **検索性・LLM 識別性** | 検索独占の見込み、AI が別物と混同しないか、商標の識別力 |

各候補は「**結論(推奨 / 要注意 / 避けるべき)**」を先頭に、取得可能性の表・衝突リスト(リンク付き)・商標所見・検索性評価。複数なら比較表と推奨順位付き。

## Engine

機械チェック部は [Almide](https://github.com/almide/almide) 製(`check.almd`)。
名前 × 11 プローブ(レジストリ 6 + ドメイン 5)を `fan.settle` で一斉並列にし、
v0.61.0 の `http.request_status` でステータスコードを直接判定する(404 = 空き、200 = 使用中)。
almide が無い環境では bash 直列版 `check.sh` にフォールバック。

## Requirements

[`almide`](https://github.com/almide/almide/releases) >= 0.61.0(推奨)/ `whois`。
フォールバックの `check.sh` は `curl` / `whois` / `bash`（macOS・Linux）。

## Caveats

- 商標 DB の正式検索(J-PlatPat / USPTO / EUIPO)は自動化していない。リスクが見えた候補は正式な商標調査(弁理士)を推奨
- GitHub API は未認証だと 60 回/時。大量候補を一度に調べると `unknown` が出得る
- **簡易調査であり法的助言ではない**

## License

[MIT](LICENSE) © 2026 O6lvl4
