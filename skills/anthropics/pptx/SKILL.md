---
name: pptx
description: "Use this skill any time a .pptx file is involved in any way — as input, output, or both. This includes: creating slide decks, pitch decks, or presentations; reading, parsing, or extracting text from any .pptx file (even if the extracted content will be used elsewhere, like in an email or summary); editing, modifying, or updating existing presentations; combining or splitting slide files; working with templates, layouts, speaker notes, or comments. Trigger whenever the user mentions \"deck,\" \"slides,\" \"presentation,\" or references a .pptx filename, regardless of what they plan to do with the content afterward. If a .pptx file needs to be opened, created, or touched, use this skill."
license: Proprietary. LICENSE.txt has complete terms
---

# PPTX Skill

## Quick Reference

| Task | Guide |
|------|-------|
| Read/analyze | `python -m markitdown presentation.pptx` |
| Edit from template | Read `editing.md` |
| Create from scratch | Read `pptxgenjs.md` + use `npm install -g pptxgenjs` |
| Visual QA | Convert to images via LibreOffice + pdftoppm |

## Design Guidelines

**Pick a bold color palette** specific to the content. Use the "sandwich" structure: dark title/conclusion slides, light content slides. Commit to ONE visual motif and repeat it.

**Never:**
- Repeat the same layout across slides
- Create text-only slides — always add images, icons, charts, or shapes
- Use accent lines under titles (hallmark of AI-generated slides)
- Default to blue without reason

**Typography**: Pair a distinctive display font with a refined body font. Titles 36-44pt, body 14-16pt.

## Converting to Images (for QA)

```bash
python scripts/office/soffice.py --headless --convert-to pdf output.pptx
pdftoppm -jpeg -r 150 output.pdf slide
```

## QA Process (Required)

**Assume there are problems.** Use subagents for visual inspection with fresh eyes:

1. Convert slides to images
2. Send to subagent with prompt: "Visually inspect these slides. Assume there are issues — find them. Look for: overlapping elements, text overflow, low contrast, leftover placeholders, uneven spacing."
3. Fix issues found
4. Re-verify affected slides

**Do not declare success until at least one fix-and-verify cycle is complete.**

## Check for Leftover Placeholders

```bash
python -m markitdown output.pptx | grep -iE "xxxx|lorem|ipsum|this.*(page|slide).*layout"
```

## Dependencies
- `pip install "markitdown[pptx]"` — text extraction
- `npm install -g pptxgenjs` — creation from scratch
- LibreOffice + Poppler — PDF/image conversion
