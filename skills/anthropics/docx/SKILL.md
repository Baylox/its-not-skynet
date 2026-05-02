---
name: docx
description: "Use this skill whenever the user wants to create, read, edit, or manipulate Word documents (.docx files). Triggers include: any mention of 'Word doc', 'word document', '.docx', or requests to produce professional documents with formatting like tables of contents, headings, page numbers, or letterheads. Also use when extracting or reorganizing content from .docx files, inserting or replacing images in documents, performing find-and-replace in Word files, working with tracked changes or comments, or converting content into a polished Word document. If the user asks for a 'report', 'memo', 'letter', 'template', or similar deliverable as a Word or .docx file, use this skill. Do NOT use for PDFs, spreadsheets, Google Docs, or general coding tasks unrelated to document generation."
license: Proprietary. LICENSE.txt has complete terms
---

# DOCX Skill

## Quick Reference

| Task | Approach |
|------|----------|
| Read/analyze | `pandoc` or unpack for raw XML |
| Create new | Use `docx-js` |
| Edit existing | Unpack → edit XML → repack |

## Creating New Documents (docx-js)

```javascript
const { Document, Packer, Paragraph, TextRun, Table, TableRow, TableCell,
        ImageRun, HeadingLevel, AlignmentType, PageBreak } = require('docx');

const doc = new Document({ sections: [{ children: [] }] });
Packer.toBuffer(doc).then(buf => fs.writeFileSync("doc.docx", buf));
```

### Critical Rules
- **Page size**: Always set explicitly — docx-js defaults to A4. US Letter = `{ width: 12240, height: 15840 }` DXA
- **Landscape**: Pass portrait dimensions + `orientation: PageOrientation.LANDSCAPE` — docx-js swaps internally
- **Never use `\n`** — use separate Paragraph elements
- **Never use unicode bullets** — use `LevelFormat.BULLET` with numbering config
- **PageBreak must be in Paragraph**: `new Paragraph({ children: [new PageBreak()] })`
- **ImageRun requires `type`**: always specify `png`/`jpg`/etc.
- **Tables**: Always `WidthType.DXA` (never PERCENTAGE), set `columnWidths` AND cell `width`, use `ShadingType.CLEAR`
- **TOC**: Headings must use `HeadingLevel` only + `outlineLevel`
- **Override built-in styles**: Use exact IDs: `"Heading1"`, `"Heading2"`, etc.

## Editing Existing Documents

1. **Unpack**: `python scripts/office/unpack.py document.docx unpacked/`
2. **Edit XML**: Use Edit tool directly for string replacement. Use `"Claude"` as author for tracked changes/comments.
3. **Pack**: `python scripts/office/pack.py unpacked/ output.docx --original document.docx`

### Tracked Changes (XML)

```xml
<!-- Insertion -->
<w:ins w:id="1" w:author="Claude" w:date="2025-01-01T00:00:00Z">
  <w:r><w:t>inserted text</w:t></w:r>
</w:ins>

<!-- Deletion -->
<w:del w:id="2" w:author="Claude" w:date="2025-01-01T00:00:00Z">
  <w:r><w:delText>deleted text</w:delText></w:r>
</w:del>
```

## Dependencies
- `pandoc` — text extraction
- `npm install -g docx` — new documents
- LibreOffice — PDF conversion via `scripts/office/soffice.py`
