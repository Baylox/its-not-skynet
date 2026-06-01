---
name: mcp-builder
description: Guide for creating high-quality MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools. Use when building MCP servers to integrate external APIs or services, whether in Python (FastMCP) or Node/TypeScript (MCP SDK).
license: Complete terms in LICENSE.txt
---

# MCP Server Development Guide

## Overview

Create MCP (Model Context Protocol) servers that enable LLMs to interact with external services through well-designed tools.

## High-Level Workflow

### Phase 1: Research and Planning
- Study MCP spec: `https://modelcontextprotocol.io/sitemap.xml`
- **Recommended stack**: TypeScript + Streamable HTTP (remote) or stdio (local)
- Load SDK docs: `https://raw.githubusercontent.com/modelcontextprotocol/typescript-sdk/main/README.md`
- Plan tool coverage: prioritize comprehensive API coverage over workflow shortcuts

### Phase 2: Implementation
- Set up project structure (see language guides in `reference/`)
- Create shared utilities: API client, error handling, response formatting, pagination
- For each tool: define input schema (Zod/Pydantic), output schema, annotations (`readOnlyHint`, `destructiveHint`, etc.)

### Phase 3: Review and Test
- Run `npm run build` (TypeScript) or `python -m py_compile` (Python)
- Test with MCP Inspector: `npx @modelcontextprotocol/inspector`

### Phase 4: Evaluations
- Create 10 realistic, complex, read-only questions that require multiple tool calls
- Verify each answer yourself before committing
- Output as XML: `<evaluation><qa_pair><question>...</question><answer>...</answer></qa_pair></evaluation>`

## Reference Files
- `reference/mcp_best_practices.md` — naming, response format, pagination, security
- `reference/node_mcp_server.md` — TypeScript patterns
- `reference/python_mcp_server.md` — Python/FastMCP patterns
- `reference/evaluation.md` — evaluation guidelines
