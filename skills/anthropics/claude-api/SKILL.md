---
name: claude-api
description: Reference for building LLM-powered applications with the Claude API / Anthropic SDK — model IDs, pricing, request parameters, streaming, tool use, MCP, prompt caching, token counting, and model migration. Use when writing or debugging code that calls Claude through an official SDK (anthropic, @anthropic-ai/sdk, etc.) or raw HTTP.
license: Complete terms in LICENSE.txt
---

# Building with the Claude API

This skill is a quick reference for writing application code against the Claude
API. Everything goes through one endpoint — `POST /v1/messages` — and tools,
structured outputs, caching, and thinking are all features of that single call.

> Pour la doc à jour (chaque ID de modèle, prix, et détail d'API évoluent),
> consulter `https://platform.claude.com/docs` plutôt que se fier à la mémoire.

## Choosing the SDK

Use the official Anthropic SDK for the project's language — `anthropic` (Python),
`@anthropic-ai/sdk` (TypeScript/JS), `com.anthropic.*` (Java/Kotlin),
`anthropic-sdk-go`, `anthropic` (Ruby), `Anthropic` (C#), `anthropic-ai/sdk` (PHP).
Use raw HTTP (`curl`, `requests`, `fetch`) only when explicitly asked or when no
SDK exists. Never mix the two in one project, and never use an OpenAI-compatible shim.

## Models (cached 2026-06 — verify via the Models API)

| Model | ID | Context | Input $/1M | Output $/1M |
|-------|----|---------|-----------|-------------|
| Claude Fable 5 | `claude-fable-5` | 1M | $10 | $50 |
| Claude Opus 4.8 | `claude-opus-4-8` | 1M | $5 | $25 |
| Claude Opus 4.7 | `claude-opus-4-7` | 1M | $5 | $25 |
| Claude Sonnet 4.6 | `claude-sonnet-4-6` | 1M | $3 | $15 |
| Claude Haiku 4.5 | `claude-haiku-4-5` | 200K | $1 | $5 |

Default to `claude-opus-4-8` unless the user asks for another tier. Use the exact
ID strings — never append date suffixes to aliases. Query the Models API
(`client.models.list()` / `.retrieve(id)`) for live context windows and capabilities.

## Basic request (Python)

```python
import anthropic

client = anthropic.Anthropic()  # reads ANTHROPIC_API_KEY from env — never hardcode

response = client.messages.create(
    model="claude-opus-4-8",
    max_tokens=16000,
    messages=[{"role": "user", "content": "What is the capital of France?"}],
)
for block in response.content:           # content is a list of blocks
    if block.type == "text":             # always check .type before .text
        print(block.text)
```

## Thinking & effort (Fable 5 / Opus 4.8 / 4.7 / 4.6, Sonnet 4.6)

- Use **adaptive thinking**: `thinking={"type": "adaptive"}`. The fixed
  `budget_tokens` form is **deprecated on 4.6 and returns a 400 on Fable 5 /
  Opus 4.8 / 4.7** — don't use it for new code.
- Control depth with `output_config={"effort": "low|medium|high|xhigh|max"}`
  (nested in `output_config`, not top-level). Default `high`.
- Reasoning text is hidden by default (`display: "omitted"`); set
  `thinking={"type": "adaptive", "display": "summarized"}` to surface a summary.

## Streaming

Stream any request that may produce long output or uses a high `max_tokens`
(>~16K) — non-streaming requests hit HTTP timeouts.

```python
with client.messages.stream(model="claude-opus-4-8", max_tokens=64000,
                            messages=[{"role": "user", "content": "Write a story"}]) as stream:
    for text in stream.text_stream:
        print(text, end="", flush=True)
    final = stream.get_final_message()
```

## Tool use

Define tools with a JSON Schema; loop until `stop_reason != "tool_use"`, returning
a `tool_result` (matching `tool_use_id`) for each call. The SDKs also ship a beta
**tool runner** that drives the loop automatically (`@beta_tool` + `tool_runner`
in Python, `betaZodTool` + `toolRunner` in TS). Return all parallel `tool_result`
blocks in a single user message. Parse `tool_use.input` with `json.loads` —
never raw-string-match.

## Prompt caching

Caching is a **prefix match** — any byte change in the prefix invalidates
everything after it. Keep stable content first (frozen system prompt,
deterministic tool order); put volatile content (timestamps, IDs) last. Mark the
last stable block with `cache_control={"type": "ephemeral"}` (max 4 breakpoints).
Verify with `usage.cache_read_input_tokens` — if it's 0 across identical-prefix
requests, a silent invalidator (`datetime.now()`, unsorted JSON, varying tools) is
at work.

## Token counting

Use `client.messages.count_tokens(model=..., messages=...)` — never `tiktoken`
(it's OpenAI's tokenizer and undercounts Claude by 15–20%+). Token counts are
model-specific; pass the same model ID you'll use for inference.

## Structured outputs

Constrain responses with `output_config={"format": {"type": "json_schema",
"schema": {...}}}` (the old top-level `output_format` is deprecated), or
`strict: true` on a tool definition for validated tool params. In Python,
`client.messages.parse(..., output_format=PydanticModel)` validates automatically.

## Model migration (key breaking changes)

- `budget_tokens` → `thinking={"type": "adaptive"}` (400 on Fable 5 / Opus 4.8 / 4.7).
- `temperature` / `top_p` / `top_k` removed on Fable 5 / Opus 4.8 / 4.7 (400) —
  steer with prompting.
- Last-assistant-turn **prefills** return 400 on the 4.6+ family and Fable 5 —
  use structured outputs or a system-prompt instruction.
- `output_format` → `output_config.format` (API-wide).
- Fable 5 only: thinking is always on (omit the `thinking` param;
  `{"type": "disabled"}` is a 400) and requires 30-day data retention.

When migrating an existing codebase, confirm the scope (which files/dirs) with the
user before editing — phrases like "migrate my project" are ambiguous about *where*.

## Errors

Catch the SDK's typed exception classes most-specific first (e.g. `NotFoundError`
→ `RateLimitError` → `APIStatusError` → `APIConnectionError`), not a single broad
catch. 429 and ≥500 are retryable (the SDK auto-retries with backoff,
`max_retries=2`); 4xx (except 429) are not.

## Environnement testé

- Outil : Claude Code
- Compatibilité déclarée : Claude Code, Codex, Antigravity CLI, Cursor
