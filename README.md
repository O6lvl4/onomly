<p align="center"><a href="README.md">English</a> | <a href="README.ja.md">日本語</a> | <a href="README.zh.md">中文</a></p>

<h1 align="center">onomly</h1>

<p align="center"><em>Vet the name before you ship it.</em></p>

<p align="center">
  <a href="https://github.com/O6lvl4/onomly/actions/workflows/ci.yml"><img src="https://github.com/O6lvl4/onomly/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
  <img src="https://img.shields.io/badge/WASI-0.3_component-654ff0" alt="WASI 0.3">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-green" alt="MIT"></a>
</p>


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

As a plugin (recommended):

```
/plugin marketplace add O6lvl4/onomly
/plugin install onomly@onomly
```

Or clone into your skills directory:

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

## CLI

The engine is also a real single-binary CLI — zero dependencies, no shell wrapper:

```sh
curl -L https://github.com/O6lvl4/onomly/releases/latest/download/onomly-macos-aarch64 -o onomly
chmod +x onomly
./onomly react vue svelte
```

(`onomly-linux-x86_64` and `onomly-linux-aarch64` are attached too; every binary is built
by CI from `onomly.almd` with the release almide compiler.)

## What it checks

| # | Angle | Details |
|---|-------|---------|
| 1 | **Mechanical check** (`onomly.almd`) | npm / crates.io / PyPI / RubyGems / Homebrew / GitHub / domains (`.com .ai .io .dev .org`, authoritative RDAP → whois) + a TMview trademark screen (JP / US / EU in one query) |
| 2 | **Existing products & trademarks** | Web search in English and Japanese: same-name products, genericized terms, collisions with well-known CS vocabulary |
| 3 | **Languages & culture** | Negative meanings / slang across EN·ES·FR·DE·ZH·JA, pronounceability, spelling uniqueness |
| 4 | **Searchability & LLM distinguishability** | Odds of owning the search results, AI confusing it with another product, trademark distinctiveness |

Each candidate leads with a **verdict (recommended / caution / avoid)**, followed by the
availability table, the collision list (with links), trademark notes, and the searchability
assessment. Multiple candidates end with a comparison table and a ranking.

## Engine

The mechanical check (`onomly.almd`) is written in [Almide](https://github.com/almide/almide).
Every probe of every name (6 registries + 5 domains) runs in one parallel `fan.settle`, and
v0.61.0's `http.request_status` reads the status code directly (404 = nobody owns it,
200 = taken). Environments without almide run the bundled `onomly.wasm` — the same engine compiled to a WASI 0.3 component (http-only: the whois TLDs `.io` / `.ai` ask for a manual check) — under wasmtime's native async; and the release page carries native single-file binaries built from the same source. No shell scripts anywhere.

## Requirements

One of, in preference order: [`almide`](https://github.com/almide/almide/releases) >= 0.61.0 + `whois` (full verdicts); [`wasmtime`](https://wasmtime.dev) >= 46 (runs the bundled WASI 0.3 component, http-only); or nothing at all — grab a native binary from [releases](https://github.com/O6lvl4/onomly/releases).

## Caveats

- The trademark screen queries TMview — one request across ~75 registers including JPO / USPTO /
  EUIPO — for same-name word marks. A screen, not clearance: no Nice-class or similarity
  judgement, so on any risk the report still says to get a formal search (an attorney) before adopting
- The GitHub API allows 60 unauthenticated requests/hour; a large batch can come back `unknown`
- **A quick survey, not legal advice**

## License

[MIT](LICENSE) © 2026 O6lvl4
