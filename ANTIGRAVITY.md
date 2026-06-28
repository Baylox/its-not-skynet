# its-not-skynet — Project Instructions (ANTIGRAVITY)

## Core Mandates

You are operating as an automated contributor for the `its-not-skynet` repository. Your primary goal is to maintain the integrity and trustworthiness of the centralized resources.

### 1. Resource Validation (NON-NEGOTIABLE)
- **NEVER** import or create a resource without personal testing or explicit contributor validation.
- **ALWAYS** set the status to `draft` in `META.md` for any newly generated resource.
- **MUST** verify that every resource has a complete `META.md` file before finalizing.

### 2. Structural Integrity
- **Folder Pattern**: `<type>/<contributor-handle>/<name>/`
- **Naming Conventions**:
    - **Hooks**: `snake_case` (e.g., `hooks/user/pre_tool_use_check/`)
    - **Skills**: `kebab-case` (e.g., `skills/user/my-new-skill/`)
    - **Configs**: `kebab-case`
- **Mandatory Files**:
    - Hook: `*.sh` + `META.md`
    - Skill: `SKILL.md` + `META.md`
    - Config: `config_file` + `META.md`

### 3. Workflow Protocol
- **Research**: Use `grep_search` and `glob` to ensure a resource doesn't already exist under a different name.
- **Execution**:
    1. Create the full structure.
    2. Populate `META.md` using the template in `CONTRIBUTING.md`.
    3. Update the parent `README.md` in the respective category folder.
- **Verification**: Use `run_shell_command` to run `bash scripts/doctor.sh` (chains lint + catalog + security audit), or `bash scripts/validate.sh` (must exit 0) then `bash scripts/build-index.sh` to refresh `CATALOG.md` + `index.json`. CI replays `test.sh`, `validate.sh`, `build-index.sh --check` and `audit-hooks.sh --strict` on every PR.

### Tooling (`scripts/`)
Pure-shell, deterministic, no network (`jq` optional): `scripts/new.sh <type> <handle> <name>` scaffolds a resource; `scripts/validate.sh` lints; `scripts/build-index.sh` regenerates the catalog + stats (`--check` verifies sync); `scripts/find.sh` searches by keyword/type/status/contributor; `scripts/audit-hooks.sh` security-scans hooks (append `# audit:allow` to silence a false positive); `scripts/doctor.sh` runs the full pre-PR check; `scripts/test.sh` tests the tooling.

## Scope & Constraints
- **Accepted**: Antigravity CLI, Claude Code, MCP, Ollama, AI CLI tools.
- **Excluded**: Unaudited npm dependencies, unverified marketplace plugins, unauthorized network calls at runtime.

## Technical Context
- **Hooks**: Favor deterministic shell scripts. If an LLM dependency is used, it MUST be declared in `META.md`.
- **Environment Variables**: Assume `$CLAUDE_PROJECT_DIR` (or equivalent for Antigravity) is available.
