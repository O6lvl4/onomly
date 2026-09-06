<p align="center"><a href="README.md">English</a> | <a href="README.ja.md">日本語</a> | <a href="README.zh.md">中文</a></p>

<h1 align="center">onomly</h1>

<p align="center"><em>发布之前,先验名。</em></p>

<p align="center">
一个为<strong>产品 / 项目名称候选做尽职调查</strong>的
<a href="https://claude.com/claude-code">Claude Code</a> 技能。<br>
按固定流程检查注册表、域名、GitHub 的可用性,同名产品与商标冲突,
多语言含义,以及搜索性 / LLM 可辨识性,返回<strong>带判定的报告</strong>。
</p>

---

> [!NOTE]
> **`onomly` 这个名字本身就是用这个工具选出来的。** 源自希腊语 *onoma*(名字)→ *onomastics*(命名学)。
> 它几乎完全通过了对自己的检查 ↓

```text
$ onomly onomly
=== onomly ===
npm ✅  crates.io ✅  RubyGems ✅  Homebrew ✅  GitHub ✅
.com ✅  .ai ✅  .io ✅  .dev ✅  .org ✅
只有 PyPI 被占用
→ 判定:所有注册表和域名全部可用
```

## Install

克隆到技能目录即可:

```sh
git clone https://github.com/O6lvl4/onomly ~/.claude/skills/onomly
```

重启 Claude Code 后即可使用 `/onomly`。

## Usage

```sh
/onomly Heartwood            # 单个候选名
/onomly Foo Bar Baz          # 多个一起(最后附对比表)
```

不带参数时会询问候选名。

## CLI

引擎也可以独立运行 — 一条命令,自动选择最佳引擎:

```sh
~/.claude/skills/onomly/onomly react vue svelte
```

检测顺序:native almide → wasmtime 运行同捆的 WASI 0.3 组件 → 串行 bash。
用 `ONOMLY_ENGINE=almide|wasm|bash` 可以强制指定(wasm 引擎无需等待 whois,最快)。

## What it checks

| # | 角度 | 内容 |
|---|------|------|
| 1 | **机械检查** (`check.almd`) | npm / crates.io / PyPI / RubyGems / Homebrew / GitHub / 域名(`.com .ai .io .dev .org`,权威 RDAP → whois) |
| 2 | **现有产品与商标** | 用英日双语做 Web 搜索:同名产品、通用词化、与知名 CS 术语的冲突 |
| 3 | **多语言与文化** | 英·西·法·德·中·日中的负面含义 / 俚语,发音难度,拼写唯一性 |
| 4 | **搜索性与 LLM 可辨识性** | 能否独占搜索结果,AI 是否会与其他产品混淆,商标显著性 |

每个候选名以**结论(推荐 / 谨慎 / 避免)**开头,随后是可用性表格、冲突列表(附链接)、
商标意见、搜索性评估。多个候选名最后附对比表与推荐排序。

## Engine

机械检查部分(`check.almd`)由 [Almide](https://github.com/almide/almide) 编写。
每个名字的全部探测(6 个注册表 + 5 个域名)通过一次 `fan.settle` 并行执行,
并用 v0.61.0 的 `http.request_status` 直接读取状态码(404 = 无人占用,200 = 已被占用)。
没有 almide 的环境会用 wasmtime 的原生 async 运行同捆的 `check.wasm`(同一引擎编译成的 WASI 0.3 组件,仅 http:`.io` / `.ai` 需手动确认);两者都没有时回退到串行 bash 版 `check.sh`。

## Requirements

按优先顺序任选其一:[`almide`](https://github.com/almide/almide/releases) >= 0.61.0 + `whois`(完整判定、最快)/ [`wasmtime`](https://wasmtime.dev) >= 46(运行同捆的 WASI 0.3 组件,仅 http)/ `curl` + `whois` + `bash`(串行回退,macOS / Linux)。

## Caveats

- 未自动化商标数据库的正式检索(J-PlatPat / USPTO / EUIPO)。发现风险的候选名,
  报告会建议在采用前进行正式商标调查(委托律师 / 代理人)
- GitHub API 未认证时限制为 60 次 / 小时,一次查询大量候选名可能返回 `unknown`
- **这只是快速调查,不构成法律意见**

## License

[MIT](LICENSE) © 2026 O6lvl4
