---
name: xlsx
description: "Use this skill any time a spreadsheet file is the primary input or output. This means any task where the user wants to: open, read, edit, or fix an existing .xlsx, .xlsm, .csv, or .tsv file (e.g., adding columns, computing formulas, formatting, charting, cleaning messy data); create a new spreadsheet from scratch or from other data sources; or convert between tabular file formats. Trigger especially when the user references a spreadsheet file by name or path — even casually (like \"the xlsx in my downloads\") — and wants something done to it or produced from it. Also trigger for cleaning or restructuring messy tabular data files (malformed rows, misplaced headers, junk data) into proper spreadsheets. The deliverable must be a spreadsheet file. Do NOT trigger when the primary deliverable is a Word document, HTML report, standalone Python script, database pipeline, or Google Sheets API integration, even if tabular data is involved."
license: Proprietary. LICENSE.txt has complete terms
---

# XLSX Skill

## Output Requirements (All Excel files)
- Professional font (Arial or Times New Roman) unless instructed otherwise
- **Zero formula errors** (#REF!, #DIV/0!, #VALUE!, #N/A, #NAME?)
- Preserve existing templates exactly when modifying files

## Financial Models — Color Coding
- **Blue text** `RGB(0,0,255)`: Hardcoded inputs
- **Black text** `RGB(0,0,0)`: All formulas
- **Green text** `RGB(0,128,0)`: Links from other worksheets
- **Red text** `RGB(255,0,0)`: External links
- **Yellow background** `RGB(255,255,0)`: Key assumptions

## Critical Rule: Use Excel Formulas, Not Hardcoded Values

```python
# WRONG
sheet['B10'] = df['Sales'].sum()  # hardcodes result

# CORRECT
sheet['B10'] = '=SUM(B2:B9)'  # Excel calculates
```

## Common Workflow

```python
# Create
from openpyxl import Workbook
wb = Workbook()
sheet = wb.active
sheet['B2'] = '=SUM(A1:A10)'
wb.save('output.xlsx')

# Edit
from openpyxl import load_workbook
wb = load_workbook('existing.xlsx')
# modify...
wb.save('modified.xlsx')

# MANDATORY after using formulas
# python scripts/recalc.py output.xlsx
```

## After Saving: Recalculate Formulas

```bash
python scripts/recalc.py output.xlsx
```

Returns JSON with error details. Fix any errors (`#REF!`, `#DIV/0!`, etc.) and recalculate again until `"status": "success"`.

## Library Selection
- **pandas**: Data analysis, bulk operations, simple data export
- **openpyxl**: Complex formatting, formulas, Excel-specific features
