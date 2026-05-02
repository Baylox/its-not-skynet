---
name: pdf
description: Use this skill whenever the user wants to do anything with PDF files. This includes reading or extracting text/tables from PDFs, combining or merging multiple PDFs into one, splitting PDFs apart, rotating pages, adding watermarks, creating new PDFs, filling PDF forms, encrypting/decrypting PDFs, extracting images, and OCR on scanned PDFs to make them searchable. If the user mentions a .pdf file or asks to produce one, use this skill.
license: Proprietary. LICENSE.txt has complete terms
---

# PDF Processing Guide

## Quick Reference

| Task | Tool |
|------|------|
| Extract text | pdfplumber / pdftotext |
| Extract tables | pdfplumber |
| Merge PDFs | pypdf / qpdf |
| Split PDFs | pypdf / qpdf |
| Create PDFs | reportlab |
| OCR scanned | pytesseract + pdf2image |
| Fill forms | See FORMS.md |

## Key Libraries

```python
from pypdf import PdfReader, PdfWriter
import pdfplumber
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
```

## Common Operations

```python
# Extract text
with pdfplumber.open("document.pdf") as pdf:
    for page in pdf.pages:
        text = page.extract_text()

# Merge
writer = PdfWriter()
for pdf_file in ["doc1.pdf", "doc2.pdf"]:
    reader = PdfReader(pdf_file)
    for page in reader.pages:
        writer.add_page(page)
with open("merged.pdf", "wb") as f:
    writer.write(f)

# Create
c = canvas.Canvas("hello.pdf", pagesize=letter)
c.drawString(100, 700, "Hello World!")
c.save()
```

## Critical Notes
- **Subscripts/superscripts**: Never use Unicode chars (₀₁₂...) in ReportLab — use `<sub>` and `<super>` XML tags in Paragraph objects
- **OCR**: Requires `pytesseract` + `pdf2image` + Tesseract installed
- For PDF forms: read FORMS.md
