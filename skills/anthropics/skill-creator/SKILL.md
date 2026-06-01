---
name: skill-creator
description: Create new skills, modify and improve existing skills, and measure skill performance. Use when users want to create a skill from scratch, edit, or optimize an existing skill, run evals to test a skill, benchmark skill performance with variance analysis, or optimize a skill's description for better triggering accuracy.
---

# Skill Creator

A skill for creating new skills and iteratively improving them.

## Process

The skill creation cycle:

1. **Decide** what the skill should do and roughly how
2. **Write** a draft of the skill
3. **Create** test prompts and run claude-with-access-to-the-skill on them
4. **Evaluate** results qualitatively and quantitatively
   - Draft quantitative evals while runs happen in background
   - Use `eval-viewer/generate_review.py` to show results
5. **Rewrite** the skill based on feedback and benchmark results
6. **Repeat** until satisfied
7. **Expand** the test set and run at larger scale

## Your Role

Figure out where the user is in this process and jump in to help them progress:

- **"I want to make a skill for X"** → Help narrow scope, write draft, write test cases, set up evals, run all prompts, iterate
- **"I already have a draft"** → Go straight to eval/iterate loop
- **"My skill isn't triggering correctly"** → Optimize the description field for better triggering accuracy
- **"Run evals"** → Execute test prompts, gather metrics, show results via `eval-viewer/generate_review.py`
