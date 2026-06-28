<div align="center">

# its-not-skynet

**Validated CLI/AI resources. No magic. No uncontrolled network. Just tools that work.**


[Quick start](#quick-start) · [Contribute with an agent](#contribute-with-an-agent) · [Contents](#contents) · [Philosophy](#why-this-repo)

[Français](docs/README.fr.md)

</div>

---

## Why this repo

The CLI/AI ecosystem is full of copy-pasted configs, untested hooks, and skills that "worked on someone's machine." **its-not-skynet** takes the opposite stance: every resource has been **created or tested in real conditions** by its author.

> **One rule, non-negotiable:** a resource is either **created** or **explicitly validated** by its contributor. Nothing imported blindly. Nothing that depends on an uncontrolled network at runtime.

A trust catalog for anyone working with CLI AI agents — Claude Code, Codex CLI, Antigravity CLI, MCP, Ollama, or any other tool.

## Contents

| Folder | Description |
|--------|-------------|
| [`hooks/`](hooks/README.md) | Shell scripts triggered by Claude Code — `PreToolUse`, `PostToolUse`, `Notification`… |
| [`skills/`](skills/README.md) | Reusable skills: slash commands and specialized agents |
| [`configs/`](configs/README.md) | Ready-to-copy config files — `settings.json`, `.mcp.json`, Ollama… |
| [`subagents/`](subagents/) | Specialized subagent definitions |
| [`architecture/`](architecture/README.md) | Architecture schemas and decisions |

Each resource has a **`META.md`**: author, status, usage, installation, tested environment.

## Quick start

1. Browse the folder you're interested in — `hooks/`, `skills/`, or `configs/`.
2. Read the resource's `META.md`.
3. Copy the installation block into your `settings.json` or project.

```jsonc
// Example: enable a hook in .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/hooks/Baylox/no_coauthor/hook.sh\"" }
        ]
      }
    ]
  }
}
```

> `$CLAUDE_PROJECT_DIR` is exposed natively by Claude Code — no `.env` required.

## Contribute with an agent

Open this repo in your CLI agent of choice and describe what you want:

> *"I want a hook that blocks commits on Fridays"*

The agent reads the project context file and generates the full structure following repo conventions:

```
hooks/<your-handle>/pre_tool_use_block_friday_commit/
├── pre_tool_use_block_friday_commit.sh
└── META.md
```

Each agent CLI has its own context file:

| Agent | Context file |
|-------|-------------|
| Claude Code | [`CLAUDE.md`](CLAUDE.md) |
| Codex CLI | [`AGENTS.md`](AGENTS.md) |
| Antigravity CLI | [`ANTIGRAVITY.md`](ANTIGRAVITY.md) |

Generated files are always **drafts**. `META.md` status stays `draft` until **you** have run the resource in real conditions. No commit before human validation — that's the repo's promise.

**You stay in control, the agent does the plumbing.**

## Tooling

Pure-shell helpers under [`scripts/`](scripts/) — deterministic, no network, no dependencies beyond coreutils (`jq` optional). The catalog of validated CLI tools gets its own validated CLI tools.

| Script | What it does |
|--------|-------------|
| `scripts/validate.sh` | Lints every resource: `META.md` present, required sections, valid status (`stable`/`beta`/`draft`), naming convention, type-specific file. Exit 0/1 — CI-friendly. |
| `scripts/build-index.sh` | Generates `CATALOG.md` + `index.json` from the filesystem + `META.md`. `--check` fails if they're out of sync. |
| `scripts/find.sh` | Searches resources by keyword / type / status / contributor — `scripts/find.sh -t hooks -s stable`. |
| `scripts/new.sh` | Scaffolds a new resource (`scripts/new.sh <type> <handle> <name>`) with a pre-filled `META.md` (status `draft`) and a stub. |

Browse the full catalog in [`CATALOG.md`](CATALOG.md). A GitHub Action runs `validate.sh` + `build-index.sh --check` on every PR.

## Conventions

| Element | Rule |
|---------|------|
| Skill folders | `kebab-case` |
| Hook / config folders | `snake_case` |
| Resource path | `<type>/<contributor-handle>/<name>/` |
| Hooks | Pure shell preferred. Any LLM dependency must be declared in `META.md`. |

## Contribute manually

Fork, create your `<type>/<handle>/<name>/` folder, add a `META.md` (template in [CONTRIBUTING.md](CONTRIBUTING.md)), test in real conditions, open a PR.

## License

Original contributor work is under **[MIT](LICENSE)**.

⚠️ **The MIT license does NOT cover third-party content.** Resources under `anthropics/` are Anthropic's exclusive property, governed solely by their own terms (`LICENSE.txt` Apache-2.0 in each folder). See the *Third-party content* section in [LICENSE](LICENSE).

---

<div align="center">

*Built by devs who test what they share.*

</div>
