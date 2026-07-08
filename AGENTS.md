# its-not-skynet — Agent context

## Purpose

Centralize CLI/AI resources validated by their authors.

## Core rule

Every resource must be either:
- created by its contributor, or
- explicitly validated by its contributor.

Do not accept imported resources without personal testing.

## Scope

Accepted:
- Claude Code resources: skills, hooks, subagents, configs
- MCP resources
- Ollama resources
- AI CLI tools

Excluded:
- unaudited npm dependencies
- unverified marketplace plugins
- anything requiring uncontrolled network access at runtime

## Repository structure

| Folder | Content |
|--------|---------|
| `hooks/` | Shell scripts run by Claude Code (`PreToolUse`, `PostToolUse`, ...) |
| `skills/` | Reusable Claude Code skills |
| `configs/` | Copyable config files (`settings.json`, `.mcp.json`, Ollama, ...) |
| `architecture/` | Architecture schemas and decisions |
| `subagents/` | Subagent definitions |

## Resource layout

Each resource lives in:

`<type>/<contributor-handle>/<name>/`

Each resource must contain a `META.md`.

`META.md` is the single entry point to understand and install a resource. It must cover:
- author
- status
- usage
- installation
- tested environment

## Contributor workflow

When a contributor describes a resource, generate the full resource structure immediately.

### Naming rules

| Type | Required files | Folder naming |
|------|----------------|---------------|
| Hook | `hook_name.sh` + `META.md` | `snake_case` |
| Skill | `SKILL.md` + `META.md` | `kebab-case` |
| Config | config file(s) + `META.md` | `kebab-case` |
| Subagent | `<name>.md` + `META.md` | `snake_case` |
| Architecture | `<name>.md` + `META.md` | `kebab-case` |

### Mandatory actions

1. Identify the resource type and contributor handle.
2. Create the folder using the required naming convention.
3. Create all required files for that resource type.
4. Fill `META.md` using the template in `CONTRIBUTING.md`.
5. Set `status: draft` in `META.md`.
6. Update the parent `README.md`.
7. Keep the resource in `draft` until tested in real conditions.
8. Do not commit it before human validation.

## Hooks

Prefer deterministic hooks implemented in pure shell.

If a hook depends on an LLM, mark that dependency explicitly in `META.md`.

## Tooling (`scripts/`)

Pure-shell, deterministic, no network (`jq` optional):
- `scripts/new.sh <type> <handle> <name>` — scaffold a resource (folder + `META.md` draft + stub; skills get a trigger-oriented description + `references/`).
- `scripts/install.sh <type>/<handle>/<name> [project]` — install a resource into a target project (`.claude/skills/<name>/`, `.claude/agents/`, `.claude/hooks/` + `settings.json` snippet). No manual copy-paste.
- `scripts/validate.sh` — lint resources (exit 0/1; skills also: frontmatter, `name`==folder, description, broken/orphan links, line budget); `scripts/build-index.sh` — regenerate `CATALOG.md` (+ stats) + `index.json` (`--check` to verify sync); `scripts/find.sh` — search by keyword/type/status/contributor.
- `scripts/audit-hooks.sh` — security scan of hook scripts (network, `curl|sh`, `eval`, `rm -rf`); advisory, `--strict` in CI. False positive: append `# audit:allow` to the line.
- `scripts/doctor.sh` — pre-PR health check chaining lint + catalog + audit with actionable hints; `--new <type> <handle> <name>` scaffolds → opens `$EDITOR` → lints in one go. `scripts/test.sh` — tests the tooling on throwaway fixtures.

Before committing a resource, run `bash scripts/doctor.sh` (or `validate.sh` then `build-index.sh`). CI replays `test.sh`, `validate.sh`, `build-index.sh --check` and `audit-hooks.sh --strict` on every PR.

## Agent checklist

Before finishing work on a new or updated resource, verify:
- the resource is in the correct `<type>/<contributor-handle>/<name>/` path
- all required files exist
- `META.md` exists and is complete
- `META.md` contains `status: draft`
- the parent `README.md` was updated
- `bash scripts/validate.sh` exits 0 and `CATALOG.md`/`index.json` are regenerated
- no claim of validation is made without real human testing
- no commit is made before human validation
