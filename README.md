<p align="center"><a href="README.md">English</a> | <a href="README.ja.md">日本語</a> | <a href="README.zh.md">中文</a></p>

<h1 align="center">onomly</h1>

<p align="center"><em>Vet the name before you ship it.</em></p>

<p align="center">
A <a href="https://claude.com/claude-code">Claude Code</a> skill for
<strong>due diligence on product / project name candidates</strong>.<br>
One fixed sweep — registry, domain, and GitHub availability; existing-product and
trademark collisions; meanings across languages; searchability and LLM
distinguishability — returning a <strong>verdict-tagged report</strong>.
</p>

---

> [!NOTE]
> **The name `onomly` itself was picked with this tool.** From Greek *onoma* (name) → *onomastics*.
> It almost fully passes its own inspection ↓

```text
$ onomly onomly
=== onomly ===
npm ✅  crates.io ✅  RubyGems ✅  Homebrew ✅  GitHub ✅
.com ✅  .ai ✅  .io ✅  .dev ✅  .org ✅
only PyPI taken
→ verdict: clear on every registry and every domain
```

## Install

Clone into your skills directory:

```sh
git clone https://github.com/O6lvl4/onomly ~/.claude/skills/onomly
```

Restart Claude Code and `/onomly` is ready.

## Usage

```sh
/onomly Heartwood            # one candidate
/onomly Foo Bar Baz          # several at once (comparison table at the end)
```

With no arguments it asks for candidates.

## What it checks

| # | Angle | Details |
|---|-------|---------|
| 1 | **Mechanical check** (`check.almd`) | npm / crates.io / PyPI / RubyGems / Homebrew / GitHub / domains (`.com .ai .io .dev .org`, authoritative RDAP → whois) |
| 2 | **Existing products & trademarks** | Web search in English and Japanese: same-name products, genericized terms, collisions with well-known CS vocabulary |
| 3 | **Languages & culture** | Negative meanings / slang across EN·ES·FR·DE·ZH·JA, pronounceability, spelling uniqueness |
| 4 | **Searchability & LLM distinguishability** | Odds of owning the search results, AI confusing it with another product, trademark distinctiveness |

Each candidate leads with a **verdict (recommended / caution / avoid)**, followed by the
availability table, the collision list (with links), trademark notes, and the searchability
assessment. Multiple candidates end with a comparison table and a ranking.

## Engine

The mechanical check (`check.almd`) is written in [Almide](https://github.com/almide/almide).
Every probe of every name (6 registries + 5 domains) runs in one parallel `fan.settle`, and
v0.61.0's `http.request_status` reads the status code directly (404 = nobody owns it,
200 = taken). Environments without almide fall back to `check.sh`, the serial bash edition.

## Requirements

[`almide`](https://github.com/almide/almide/releases) >= 0.61.0 (recommended) / `whois`.
The `check.sh` fallback needs `curl` / `whois` / `bash` (macOS / Linux).

## Caveats

- Formal trademark-database searches (J-PlatPat / USPTO / EUIPO) are not automated. When a
  candidate shows risk, the report says to get a formal trademark search (an attorney) before adopting
- The GitHub API allows 60 unauthenticated requests/hour; a large batch can come back `unknown`
- **A quick survey, not legal advice**

## License

[MIT](LICENSE) © 2026 O6lvl4
