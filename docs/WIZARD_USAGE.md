# 🦫 Bebras Wizard - Quick Start Guide

## Overview

The Bebras Wizard is an interactive script that automates the entire Bebras document processing pipeline. Instead of running multiple scripts manually, simply run the wizard and answer a few questions!

## Quick Start

```bash
# Navigate to your project directory
cd /path/to/your/bebras/project

# Run the wizard
./scripts/bebras_wizard.sh
```

## What the Wizard Does

The wizard will guide you through these steps:

### 📋 Input Collection
1. **Competition Year** - Enter the year (e.g., 2025)
2. **Excel File Path** - Point to your "Bebras India YYYY tasks.xlsx" file
3. **ZIP File Path** - Point to your ZIP file containing all task documents
4. **Target Languages** - Specify which languages to process (comma-separated)
5. **Template File Path** - Point to your blank Word template file

### ✅ Validation & Sanity Checks
- Validates year format (4-digit year between 2020-2027)
- Checks all files exist and are readable
- Validates language codes against supported languages
- Confirms all prerequisites are installed

### 🔄 Automatic Processing
1. **Creates working directory** - `bebras_YYYY/` in current location
2. **Extracts tasks** - Reads Excel column O and creates `tasks.txt`
3. **Extracts ZIP** - Unzips all task files into `tasks/` directory
4. **Organizes by language** - Sorts files into language-specific folders
5. **Numbers for mail merge** - Creates sequentially numbered files in `Processed/`

### 📁 Final Output Structure
```
bebras_YYYY/
├── tasks.txt                          # Extracted task list
├── tasks/                             # All extracted .docx files
├── EN/, GU/, MR/, etc.                # Organized by language
└── Processed/                         # Final numbered files
    ├── EN/
    │   ├── BebrasYYYY_questions_and_solutions_EN.docx
    │   ├── 1_TaskName_EN.docx
    │   ├── 2_TaskName_EN_SOLN.docx
    │   ├── 3_NextTask_EN.docx
    │   └── ...
    ├── GU/, MR/, etc.
```

## Supported Languages

The wizard supports these language codes:
- **EN** - English
- **GU** - Gujarati  
- **MR** - Marathi
- **KA** - Kannada
- **TA** - Tamil
- **OR** - Odia
- **TE** - Telugu
- **HI** - Hindi
- **BN** - Bengali
- **PA** - Punjabi

## Input Examples

### Year
```
📅 Enter the competition year (e.g., 2025): 2025
```

### Excel File
```
📊 Enter path to Excel file: /Users/apple/Desktop/Bebras India 2025 tasks.xlsx
```

### ZIP File
```
📦 Enter path to ZIP file: /Users/apple/Desktop/bebras-tasks-2025.zip
```

### Languages
```
🌐 Enter target languages: EN,GU,MR,HI
```

### Template File
```
📄 Enter path to blank Word template: /Users/apple/Desktop/Bebras_questions_and_solutions_empty.docx
```

## Final Step - Word Document Merge

After the wizard completes, you'll get detailed instructions for the final merge:

### macOS Users
1. Open your language template file (e.g., `BebrasYYYY_questions_and_solutions_EN.docx`)
2. Open Finder → Navigate to `bebras_YYYY/Processed/[LANGUAGE]/`
3. Select all numbered files (`1_`, `2_`, `3_`, etc.) - **NOT the template**
4. **Drag and drop** selected files into the open Word document
5. Word automatically inserts content in numerical order

### Windows Users
1. Open your language template file (e.g., `BebrasYYYY_questions_and_solutions_EN.docx`)
2. Click **Insert → Object → Text from File**
3. Navigate to `bebras_YYYY\\Processed\\[LANGUAGE]\\`
4. **Multi-select** all numbered files (Ctrl+click) - **NOT the template**
5. Click **Insert** to merge all files

## Error Handling

The wizard includes comprehensive error handling:

### Common Issues & Solutions

**"Python packages not found"**
- The wizard auto-installs required packages (`pandas`, `openpyxl`)

**"File not found"**
- Check file paths are correct and files exist
- Ensure you have read permissions

**"Invalid language code"**
- Use supported language codes (EN, GU, MR, etc.)
- Separate multiple languages with commas

**"ZIP extraction failed"**
- Ensure ZIP file is not corrupted
- Check you have `unzip` command installed

## Advanced Usage

### Batch Mode (Future Enhancement)
For automation, you can pre-set environment variables:

```bash
export BEBRAS_YEAR="2025"
export BEBRAS_EXCEL="/path/to/excel.xlsx"
export BEBRAS_ZIP="/path/to/tasks.zip"
export BEBRAS_LANGUAGES="EN,GU,MR,HI"
export BEBRAS_TEMPLATE="/path/to/template.docx"
./scripts/bebras_wizard.sh
```

### Custom Working Directory
The wizard creates `bebras_YYYY/` in your current directory. To use a different location:

```bash
cd /desired/output/location
/path/to/bebras/scripts/bebras_wizard.sh
```

## Security Notes

🔒 **The wizard keeps all sensitive files local:**
- Original task files remain in the ZIP
- Excel files are only read, never modified
- Working directory contains only processed copies
- No sensitive data is transmitted or shared

## Troubleshooting

### Prerequisites Check Failed
```bash
# Install missing tools
brew install python3  # macOS
sudo apt-get install python3 unzip  # Ubuntu/Debian
```

### Permission Errors
```bash
# Make wizard executable
chmod +x scripts/bebras_wizard.sh

# Fix file permissions
chmod +r /path/to/your/files/*
```

### Memory Issues with Large Files
- Process languages one at a time
- Split large ZIP files if necessary
- Ensure sufficient disk space (2-3x ZIP file size)

## Getting Help

If you encounter issues:

1. **Check Prerequisites** - Python 3, unzip command
2. **Verify File Paths** - All input files exist and are readable
3. **Review Error Messages** - The wizard provides detailed error information
4. **Check Disk Space** - Ensure adequate space for extraction and processing

## Examples

### Complete Wizard Run Example

```bash
$ ./scripts/bebras_wizard.sh

╔═══════════════════════════════════════════════════════╗
║           🦫 BEBRAS DOCUMENT PROCESSING WIZARD         ║
╚═══════════════════════════════════════════════════════╝

ℹ️  Checking prerequisites...
✅ Prerequisites check passed

📋 STEP: Collecting Input Parameters

📅 Enter the competition year (e.g., 2025) [2025]: 2025
✅ Year 2025 validated

📊 Enter path to Excel file: /Users/apple/Desktop/Bebras India 2025 tasks.xlsx
✅ Excel file validated: /Users/apple/Desktop/Bebras India 2025 tasks.xlsx

📦 Enter path to ZIP file: /Users/apple/Desktop/tasks.zip
✅ ZIP file validated: /Users/apple/Desktop/tasks.zip

🌐 Enter target languages [EN,GU,MR,HI]: EN,GU,HI
✅ Languages validated: EN,GU,HI

📄 Enter path to blank Word template: /Users/apple/Desktop/template.docx
✅ Template file validated: /Users/apple/Desktop/template.docx

✅ All inputs validated successfully!

📋 STEP: Configuration Summary
Year: 2025
Excel file: /Users/apple/Desktop/Bebras India 2025 tasks.xlsx
ZIP file: /Users/apple/Desktop/tasks.zip
Languages: EN,GU,HI
Template: /Users/apple/Desktop/template.docx

🚀 Proceed with processing? (y/N) [N]: y

[Processing steps execute automatically...]

📋 STEP: FINAL INSTRUCTIONS

🎉 Bebras document processing completed successfully!

📁 All processed files are in: /Users/apple/current/dir/bebras_2025/Processed/

⚠️  📋 NEXT STEPS - Word Document Merge:
[Detailed instructions for macOS and Windows...]
```

This wizard transforms a complex multi-step process into a simple Q&A session!