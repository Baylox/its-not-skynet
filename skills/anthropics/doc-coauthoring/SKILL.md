---
name: doc-coauthoring
description: Guide users through a structured workflow for co-authoring documentation. Use when user wants to write documentation, proposals, technical specs, decision docs, or similar structured content. This workflow helps users efficiently transfer context, refine content through iteration, and verify the doc works for readers. Trigger when user mentions writing docs, creating proposals, drafting specs, or similar documentation tasks.
---

# Doc Co-Authoring Workflow

This skill provides a structured workflow for guiding users through collaborative document creation. Act as an active guide, walking users through three stages: Context Gathering, Refinement & Structure, and Reader Testing.

## When to Offer This Workflow

**Trigger conditions:**
- User mentions writing documentation: "write a doc", "draft a proposal", "create a spec", "write up"
- User mentions specific doc types: "PRD", "design doc", "decision doc", "RFC"
- User seems to be starting a substantial writing task

## Stage 1: Context Gathering

**Goal:** Close the gap between what the user knows and what Claude knows, enabling smart guidance later.

Ask the user for meta-context: document type, primary audience, desired impact, template/format, and any constraints. Encourage them to dump all context they have without organizing it.

**Exit condition:** Sufficient context gathered when questions show understanding of edge cases and trade-offs.

## Stage 2: Refinement & Structure

**Goal:** Build the document section by section through brainstorming, curation, and iterative refinement.

For each section:
1. Ask clarifying questions
2. Brainstorm 5-20 options
3. User curates what to keep/remove/combine
4. Draft the section
5. Refine through surgical edits (use `str_replace`, never reprint whole doc)

## Stage 3: Reader Testing

**Goal:** Test the document with a fresh Claude (no context bleed) to verify it works for readers.

If sub-agents available: test directly by predicting reader questions and running them through a sub-agent with only the document content.

If no sub-agents: guide the user to open a fresh Claude conversation and test manually.

**Exit condition:** Reader Claude consistently answers questions correctly with no new gaps surfaced.
