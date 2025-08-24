# Bebras Document Processing Pipeline 2025

## Overview

This document provides step-by-step instructions for processing Bebras tasks for the annual competition. The process involves extracting task lists from Excel files, organizing files by language, and preparing numbered documents for mail merge operations. This system is designed to work on both macOS/Linux and Windows platforms.

## Prerequisites

### Software Requirements
- Python 3.x with `pandas` and `openpyxl` libraries
- Terminal/Command Prompt access
- Microsoft Word (for final merge operations)
- Text editor (optional, for manual edits)

### File Structure
Your project directory should contain:
```
/bebras/YYYY/
├── Bebras India YYYY tasks.xlsx       # Main task list Excel file
├── Bebras_questions_and_solutions_empty.docx  # Template document
├── tasks/                             # Directory containing all task files
│   ├── 2025-XX-##_TaskName_EN.docx   # English task files
│   ├── 2025-XX-##-EN_Soln.docx      # English solution files  
│   └── ... (other language files)
├── scripts/                          # Generated scripts
├── docs/                            # Documentation
└── Processed/                       # Generated output directory
```

## File Naming Conventions

### Expected Input File Patterns
- **Question files**: `YYYY-CC-##_EN.docx` (e.g., `2025-CA-01_EN.docx`)
- **Solution files**: `YYYY-CC-##-EN_Soln.docx` (e.g., `2025-CA-01-EN_Soln.docx`)
- **Language variants**: Replace `EN` with language code (`GU`, `MR`, `KA`, `TA`, `OR`, `TE`, `HI`, `BN`, `PA`)

### Language Codes
- **EN**: English
- **GU**: Gujarati  
- **MR**: Marathi
- **KA**: Kannada
- **TA**: Tamil
- **OR**: Odia
- **TE**: Telugu
- **HI**: Hindi
- **BN**: Bengali
- **PA**: Punjabi

## Step-by-Step Process

### Step 1: Prepare Task List

#### 1.1 Extract Tasks from Excel File

Create and run the Python extraction script:

```python
# File: scripts/extract_tasks.py
#!/usr/bin/env python3
"""
Script to extract task names from Bebras India YYYY tasks Excel file
Extracts values from column O starting from row 2 and saves to tasks.txt
"""

import pandas as pd
import sys
import os

def extract_tasks():
    """Extract tasks from Excel file O2:O column and save to tasks.txt"""
    
    # Update this path for your year
    excel_file = "/path/to/bebras/YYYY/Bebras India YYYY tasks .xlsx"
    
    if not os.path.exists(excel_file):
        print(f"Error: Excel file not found at {excel_file}")
        return False
    
    try:
        # Read the Excel file
        print(f"Reading Excel file: {excel_file}")
        df = pd.read_excel(excel_file)
        
        # Get column O (index 14, since A=0, B=1, ..., O=14)
        if len(df.columns) <= 14:
            print(f"Error: Excel file doesn't have column O (only {len(df.columns)} columns)")
            return False
        
        column_o = df.iloc[:, 14]  # Column O (15th column, 0-indexed)
        
        # Filter out NaN values, blank strings, and underscore-only entries from row 2 onwards
        tasks = column_o[1:].dropna().astype(str).str.strip()
        tasks = [task for task in tasks if task and task != '' and task != 'nan' and task != '_']
        
        if not tasks:
            print("No tasks found in column O starting from row 2")
            return False
        
        # Save to tasks.txt
        output_file = "/path/to/bebras/YYYY/tasks.txt"
        with open(output_file, 'w', encoding='utf-8') as f:
            for task in tasks:
                f.write(f"{task}\\n")
        
        print(f"Successfully extracted {len(tasks)} tasks to {output_file}")
        print(f"First few tasks:")
        for i, task in enumerate(tasks[:5]):
            print(f"  {i+1}. {task}")
        
        return True
        
    except Exception as e:
        print(f"Error processing Excel file: {e}")
        return False

if __name__ == "__main__":
    success = extract_tasks()
    sys.exit(0 if success else 1)
```

**Run the script:**
```bash
# Install required packages first
pip install pandas openpyxl

# Run extraction
python scripts/extract_tasks.py
```

This creates `tasks.txt` with the ordered list of tasks.

### Step 2: Organize Files by Language

#### 2.1 Create Language Organization Script

**macOS/Linux Version:**

```bash
# File: organize_bebras.sh
#!/bin/bash

# Remove existing language folders if present
rm -rf "/path/to/bebras/YYYY/GU"
rm -rf "/path/to/bebras/YYYY/EN"
rm -rf "/path/to/bebras/YYYY/KA"
rm -rf "/path/to/bebras/YYYY/MR"
rm -rf "/path/to/bebras/YYYY/OR"
rm -rf "/path/to/bebras/YYYY/TA"
rm -rf "/path/to/bebras/YYYY/TE"
rm -rf "/path/to/bebras/YYYY/HI"
rm -rf "/path/to/bebras/YYYY/BN"
rm -rf "/path/to/bebras/YYYY/PA"

# Create language directories
mkdir -p "/path/to/bebras/YYYY/GU"
mkdir -p "/path/to/bebras/YYYY/EN"
mkdir -p "/path/to/bebras/YYYY/KA"
mkdir -p "/path/to/bebras/YYYY/MR"
mkdir -p "/path/to/bebras/YYYY/OR"
mkdir -p "/path/to/bebras/YYYY/TA"
mkdir -p "/path/to/bebras/YYYY/TE"
mkdir -p "/path/to/bebras/YYYY/HI"
mkdir -p "/path/to/bebras/YYYY/BN"
mkdir -p "/path/to/bebras/YYYY/PA"

# Copy files from tasks directory
cd tasks

# Copy files for each language (case-insensitive search for SOLN/soln)
# Copy GU files
find . -iname "*GU.docx" -exec cp {} "/path/to/bebras/YYYY/GU/" \\;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/path/to/bebras/YYYY/GU/" \\;

# Copy EN files  
find . -iname "*EN.docx" -exec cp {} "/path/to/bebras/YYYY/EN/" \\;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/path/to/bebras/YYYY/EN/" \\;

# Repeat for all other languages...
# [Include similar blocks for KA, MR, OR, TA, TE, HI, BN, PA]

echo "Files organized successfully!"
```

**Windows Version:**
```batch
REM File: organize_bebras.bat
mkdir "C:\\tmp\\BebrasYYYY\\GU"
mkdir "C:\\tmp\\BebrasYYYY\\EN"
REM ... (create all language directories)

REM Copy files recursively
for /r %%i in (*GU.docx) do xcopy /Y "%%i" "C:\\tmp\\BebrasYYYY\\GU"
for /r %%i in (*EN_SOLN.docx) do xcopy /Y "%%i" "C:\\tmp\\BebrasYYYY\\GU"
REM ... (repeat for all languages)
```

#### 2.2 Run Organization Script

```bash
# Make executable and run (macOS/Linux)
chmod +x organize_bebras.sh
./organize_bebras.sh

# Windows
organize_bebras.bat
```

### Step 3: Process and Number Files

#### 3.1 Create Processing Script

The most critical script that numbers files sequentially for mail merge:

**⚠️ Important: This script requires the template file `Bebras_questions_and_solutions_empty.docx` to exist in the project root directory. The script will check for this file and stop with an error message if it's not found.**

```bash
# File: process_bebras_final.sh
#!/bin/bash

# Remove existing processed folder and recreate
echo "Removing existing Processed folder and recreating..."
rm -rf "/path/to/bebras/YYYY/Processed"
mkdir -p "/path/to/bebras/YYYY/Processed"
cd "/path/to/bebras/YYYY/Processed"

# Create language directories
mkdir -p EN MR GU KA TA OR TE HI BN PA

echo "Created language directories in Processed folder"

# Check if template file exists before proceeding
template_file="/path/to/bebras/YYYY/Bebras_questions_and_solutions_empty.docx"
if [ ! -f "$template_file" ]; then
    echo "ERROR: Template file not found: $template_file"
    echo "Please ensure Bebras_questions_and_solutions_empty.docx exists in the project root directory"
    echo "Script cannot continue without the template file."
    exit 1
fi

# Copy blank template to each language directory
echo "Copying blank templates..."
cp "$template_file" "EN/BebrasYYYY_questions_and_solutions_EN.docx"
cp "$template_file" "GU/BebrasYYYY_questions_and_solutions_GU.docx"
# ... (repeat for all languages)

# Process tasks from tasks.txt
echo "Processing tasks from tasks.txt..."
count=0

if [ ! -f "/path/to/bebras/YYYY/tasks.txt" ]; then
    echo "Error: tasks.txt not found"
    exit 1
fi

while IFS= read -r task; do
    if [ -z "$task" ]; then
        continue
    fi
    
    echo "***Processing for $task***"
    
    # Extract task ID (e.g., 2025-CA-01 from 2025-CA-01_Robot_Assembly)
    task_id=$(echo "$task" | sed 's/_.*$//')
    
    # CRITICAL: Increment count first (follows original batch logic)
    ((count++))
    
    # Process EN first
    echo "Copying EN..."
    if cp "/path/to/bebras/YYYY/EN/${task_id}_EN.docx" "/path/to/bebras/YYYY/Processed/EN/${count}_${task}_EN.docx" 2>/dev/null; then
        # Question file copied successfully, now increment count and copy solution
        ((count++))
        echo "Copying solutions to EN..."
        for soln_file in "/path/to/bebras/YYYY/EN/${task_id}-EN_Soln.docx" "/path/to/bebras/YYYY/EN/${task_id}-EN_SOLN.docx"; do
            if [ -f "$soln_file" ]; then
                cp "$soln_file" "/path/to/bebras/YYYY/Processed/EN/${count}_${task}_EN_SOLN.docx"
                break
            fi
        done
    fi
    
    # Process other languages (increment counter for each successful copy)
    for lang in BN PA HI MR GU KA OR TA TE; do
        echo "Copying $lang..."
        if cp "/path/to/bebras/YYYY/$lang/${task_id}_${lang}.docx" "/path/to/bebras/YYYY/Processed/$lang/${count}_${task}_${lang}.docx" 2>/dev/null; then
            ((count++))
        fi
    done
    
    echo "***DONE Processing for $task***"
    echo ""
    
done < "/path/to/bebras/YYYY/tasks.txt"

echo "Processing complete! Total files processed: $count"
```

#### 3.2 Run Processing Script

```bash
# Make executable and run
chmod +x process_bebras_final.sh
./process_bebras_final.sh
```

## Understanding the Numbering Logic

The numbering system is crucial for mail merge operations:

1. **Counter starts at 0**
2. **For each task iteration:**
   - Counter increments first (`count++`)
   - English question gets current counter value
   - If question copy succeeds, counter increments again
   - English solution gets new counter value
   - Each other language file gets current counter and increments if successful

**Example numbering sequence:**
```
1_2025-CA-01_Robot_Assembly_EN.docx      (Question)
2_2025-CA-01_Robot_Assembly_EN_SOLN.docx (Solution) 
3_2025-IS-03_Pizza_Machine_EN.docx       (Next Question)
4_2025-IS-03_Pizza_Machine_EN_SOLN.docx  (Next Solution)
```

This ensures questions and solutions appear in the correct order during Word mail merge.

## File Verification

After processing, verify your results:

```bash
# Check file counts
ls -la Processed/EN/ | wc -l
ls -la Processed/*/

# Verify numbering sequence
ls -la Processed/EN/ | head -10
```

Expected output should show sequential numbering with questions and solutions alternating.

## Word Document Merge Process

### Step 1: Open Template Document
1. Open the appropriate language template (e.g., `BebrasYYYY_questions_and_solutions_EN.docx`)

### Step 2: Insert Documents
1. Click **Insert** → **Object** → **Text from File**
2. Navigate to the `Processed/EN/` directory
3. Select all numbered files (1_, 2_, 3_, etc.)
4. Click **Insert**

### Step 3: Verify Merge
1. Check that the last solution appears in the merged document
2. Word sometimes stops mid-process - if this happens:
   - Note the last inserted file number
   - Repeat the insert process starting from the next file
   - Continue until all files are merged

## Troubleshooting

### Common Issues

#### Issue: "ERROR: Template file not found" 
**Solution**:
- Ensure `Bebras_questions_and_solutions_empty.docx` exists in the project root directory
- Verify the file name is exactly `Bebras_questions_and_solutions_empty.docx`
- Check file permissions - the script needs read access to the template file

#### Issue: "File not found" errors during processing
**Solution**: 
- Verify task names in `tasks.txt` exactly match file names
- Check for special characters (apostrophes, spaces, hyphens)
- Ensure underscores are used instead of spaces in filenames

#### Issue: Missing solution files
**Solution**:
- Solutions only exist in English
- Not all questions have solutions
- Review with content team to confirm which solutions should be available

#### Issue: Incorrect file numbering
**Solution**:
- Re-run the processing script from scratch
- Verify the counter logic in your script matches the provided template
- Ensure the Processed folder is completely clean before reprocessing

#### Issue: Word merge stops midway
**Solution**:
- Note the last successfully inserted file
- Continue insertion from the next numbered file
- This is a Word limitation with large numbers of files

### File Path Updates

When using this process for a new year, update these paths in ALL scripts:

```bash
# Update year in all file paths
/path/to/bebras/YYYY/           # Main directory
BebrasYYYY_questions_*          # Template names  
"Bebras India YYYY tasks.xlsx"  # Excel filename
```

## Directory Structure After Completion

```
/bebras/YYYY/
├── Bebras India YYYY tasks.xlsx
├── Bebras_questions_and_solutions_empty.docx
├── tasks.txt
├── EN/                        # Organized by language
│   ├── 2025-CA-01_EN.docx
│   ├── 2025-CA-01-EN_Soln.docx
│   └── ...
├── GU/                        # Other languages
├── MR/, KA/, TA/, OR/, TE/, HI/, BN/, PA/
├── Processed/                 # Final numbered files
│   ├── EN/
│   │   ├── BebrasYYYY_questions_and_solutions_EN.docx
│   │   ├── 1_TaskName_EN.docx
│   │   ├── 2_TaskName_EN_SOLN.docx
│   │   ├── 3_NextTask_EN.docx
│   │   └── ...
│   ├── GU/, MR/, KA/, etc.
├── scripts/
│   ├── extract_tasks.py
│   ├── organize_bebras.sh
│   └── process_bebras_final.sh
└── docs/
    └── README.md (this file)
```

## Quality Assurance Checklist

Before finalizing:

- [ ] Verify `tasks.txt` contains the correct number of tasks
- [ ] Confirm all language directories have expected files
- [ ] Check that numbering is sequential in Processed directories
- [ ] Test Word merge with a small subset first
- [ ] Verify solutions only appear for questions that have them
- [ ] Confirm template documents were copied to all language directories
- [ ] Double-check file naming conventions match expected patterns

## Notes for Next Year

- Save this README with the processed files for future reference
- Update all YYYY placeholders with the actual year
- Verify Excel file structure hasn't changed (column O assumption)
- Test scripts with a small subset before processing all files
- Document any manual corrections needed for specific tasks

This completes the Bebras document processing pipeline. The system is designed to be reproducible and can be executed by following these steps in sequence.