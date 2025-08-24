#!/bin/bash

# Bebras Document Processing Wizard
# Interactive script to process Bebras competition tasks
# Author: Auto-generated for Bebras India

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Global variables
YEAR=""
EXCEL_FILE=""
ZIP_FILE=""
LANGUAGES=""
TEMPLATE_FILE=""
WORKING_DIR=""

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_step() {
    echo -e "${BLUE}📋 STEP: $1${NC}"
}

# Function to prompt user for input
prompt_input() {
    local prompt="$1"
    local var_name="$2"
    local default_value="$3"
    
    if [ -n "$default_value" ]; then
        echo -n -e "${YELLOW}$prompt [$default_value]: ${NC}"
        read user_input
        if [ -z "$user_input" ]; then
            user_input="$default_value"
        fi
    else
        echo -n -e "${YELLOW}$prompt: ${NC}"
        read user_input
    fi
    
    eval "$var_name=\"$user_input\""
}

# Function to validate year input
validate_year() {
    if [[ ! "$YEAR" =~ ^[0-9]{4}$ ]]; then
        print_error "Invalid year format. Please enter a 4-digit year (e.g., 2025)"
        return 1
    fi
    
    current_year=$(date +%Y)
    if [ "$YEAR" -lt 2020 ] || [ "$YEAR" -gt $((current_year + 2)) ]; then
        print_error "Year should be between 2020 and $((current_year + 2))"
        return 1
    fi
    
    print_success "Year $YEAR validated"
    return 0
}

# Function to validate file exists
validate_file_exists() {
    local file_path="$1"
    local file_type="$2"
    
    if [ ! -f "$file_path" ]; then
        print_error "$file_type not found: $file_path"
        return 1
    fi
    
    if [ ! -r "$file_path" ]; then
        print_error "$file_type is not readable: $file_path"
        return 1
    fi
    
    print_success "$file_type validated: $file_path"
    return 0
}

# Function to validate languages
validate_languages() {
    # Convert to array and validate each language
    IFS=',' read -ra LANG_ARRAY <<< "$LANGUAGES"
    VALID_LANGUAGES=("EN" "GU" "MR" "KA" "TA" "OR" "TE" "HI" "BN" "PA")
    
    PROCESSED_LANGUAGES=""
    for lang in "${LANG_ARRAY[@]}"; do
        # Trim whitespace and convert to uppercase
        lang=$(echo "$lang" | tr '[:lower:]' '[:upper:]' | tr -d '[:space:]')
        
        # Check if language is valid
        if [[ " ${VALID_LANGUAGES[@]} " =~ " $lang " ]]; then
            if [ -n "$PROCESSED_LANGUAGES" ]; then
                PROCESSED_LANGUAGES="$PROCESSED_LANGUAGES,$lang"
            else
                PROCESSED_LANGUAGES="$lang"
            fi
        else
            print_warning "Invalid language code: $lang (skipping)"
        fi
    done
    
    if [ -z "$PROCESSED_LANGUAGES" ]; then
        print_error "No valid languages specified"
        print_info "Valid languages: ${VALID_LANGUAGES[*]}"
        return 1
    fi
    
    LANGUAGES="$PROCESSED_LANGUAGES"
    print_success "Languages validated: $LANGUAGES"
    return 0
}

# Function to set up working directory
setup_working_directory() {
    WORKING_DIR="$(pwd)/bebras_$YEAR"
    
    if [ -d "$WORKING_DIR" ]; then
        print_warning "Working directory already exists: $WORKING_DIR"
        prompt_input "Remove existing directory and continue? (y/N)" confirm "N"
        if [[ "$confirm" =~ ^[Yy] ]]; then
            rm -rf "$WORKING_DIR"
            print_success "Removed existing directory"
        else
            print_error "Cannot continue with existing directory"
            exit 1
        fi
    fi
    
    mkdir -p "$WORKING_DIR"
    print_success "Created working directory: $WORKING_DIR"
}

# Function to extract tasks from Excel
extract_tasks() {
    print_step "Extracting tasks from Excel file"
    
    # Create Python script for extraction
    # Convert relative path to absolute path to avoid issues
    EXCEL_FILE_ABS="$(cd "$(dirname "$EXCEL_FILE")" && pwd)/$(basename "$EXCEL_FILE")"
    
    cat > "$WORKING_DIR/extract_tasks.py" << EOF
#!/usr/bin/env python3
import pandas as pd
import sys
import os

def extract_tasks():
    excel_file = os.path.abspath(r"$EXCEL_FILE_ABS")
    
    try:
        print(f"Reading Excel file: {excel_file}")
        if not os.path.exists(excel_file):
            print(f"Error: Excel file does not exist: {excel_file}")
            return False
            
        df = pd.read_excel(excel_file)
        
        if len(df.columns) <= 14:
            print(f"Error: Excel file doesn't have column O (only {len(df.columns)} columns)")
            return False
        
        column_o = df.iloc[:, 14]  # Column O
        tasks = column_o[1:].dropna().astype(str).str.strip()
        tasks = [task for task in tasks if task and task != '' and task != 'nan' and task != '_']
        
        if not tasks:
            print("No tasks found in column O starting from row 2")
            return False
        
        output_file = os.path.abspath(r"$WORKING_DIR/tasks.txt")
        with open(output_file, 'w', encoding='utf-8') as f:
            for task in tasks:
                f.write(f"{task}\\n")
        
        print(f"Successfully extracted {len(tasks)} tasks to {output_file}")
        return True
        
    except Exception as e:
        print(f"Error processing Excel file: {e}")
        return False

if __name__ == "__main__":
    success = extract_tasks()
    sys.exit(0 if success else 1)
EOF

    # Check if pandas is available
    if ! python3 -c "import pandas, openpyxl" 2>/dev/null; then
        print_error "Required Python packages not found. Installing pandas and openpyxl..."
        pip3 install pandas openpyxl || {
            print_error "Failed to install required packages"
            exit 1
        }
    fi
    
    # Run extraction
    cd "$WORKING_DIR"
    if python3 extract_tasks.py; then
        print_success "Task extraction completed"
        task_count=$(wc -l < tasks.txt)
        print_info "Extracted $task_count tasks"
    else
        print_error "Task extraction failed"
        exit 1
    fi
    cd - > /dev/null
}

# Function to extract and organize task files
extract_and_organize_files() {
    print_step "Extracting and organizing task files"
    
    # Convert ZIP file path to absolute path to avoid issues
    if [[ "$ZIP_FILE" = /* ]]; then
        # Already absolute path
        ZIP_FILE_ABS="$ZIP_FILE"
    else
        # Convert relative path to absolute
        ZIP_FILE_ABS="$(pwd)/$ZIP_FILE"
    fi
    
    # Extract ZIP file
    print_info "Extracting ZIP file: $ZIP_FILE"
    print_info "Using absolute path: $ZIP_FILE_ABS"
    cd "$WORKING_DIR"
    
    # Create tasks directory
    mkdir -p tasks
    
    # Extract ZIP
    if command -v unzip >/dev/null 2>&1; then
        unzip -q "$ZIP_FILE_ABS" -d tasks/ || {
            print_error "Failed to extract ZIP file"
            exit 1
        }
    else
        print_error "unzip command not found. Please install unzip"
        exit 1
    fi
    
    print_success "ZIP file extracted"
    
    # Count extracted files
    file_count=$(find tasks -name "*.docx" -print0 | grep -zc .)
    print_info "Found $file_count .docx files"
    
    cd - > /dev/null
}

# Function to organize files by language
organize_by_language() {
    print_step "Organizing files by language"
    
    cd "$WORKING_DIR"
    
    # Create language directories
    IFS=',' read -ra LANG_ARRAY <<< "$LANGUAGES"
    for lang in "${LANG_ARRAY[@]}"; do
        mkdir -p "$lang"
        print_info "Created directory for $lang"
    done
    
    # Move files to appropriate directories
    cd tasks
    
    for lang in "${LANG_ARRAY[@]}"; do
        print_info "Processing $lang files..."
        
        # Find and copy language-specific files (case insensitive)
        find . -iname "*_${lang}.docx" -exec cp '{}' "../$lang/" \\; 2>/dev/null || true
        
        # Copy solution files (case insensitive for both SOLN and soln)
        find . -iname "*_EN_[Ss][Oo][Ll][Nn].docx" -exec cp '{}' "../$lang/" \\; 2>/dev/null || true
        find . -iname "*-EN_[Ss][Oo][Ll][Nn].docx" -exec cp '{}' "../$lang/" \\; 2>/dev/null || true
        
        lang_file_count=$(ls "../$lang" 2>/dev/null | wc -l)
        print_info "$lang: $lang_file_count files"
    done
    
    cd - > /dev/null
    print_success "File organization completed"
}

# Function to process and number files
process_and_number_files() {
    print_step "Processing and numbering files for mail merge"
    
    cd "$WORKING_DIR"
    
    # Create processed directory structure
    rm -rf Processed
    mkdir -p Processed
    cd Processed
    
    IFS=',' read -ra LANG_ARRAY <<< "$LANGUAGES"
    for lang in "${LANG_ARRAY[@]}"; do
        mkdir -p "$lang"
    done
    
    print_success "Created Processed directory structure"
    
    # Copy template files
    for lang in "${LANG_ARRAY[@]}"; do
        cp "$TEMPLATE_FILE" "$lang/Bebras${YEAR}_questions_and_solutions_${lang}.docx"
        print_info "Copied template to $lang directory"
    done
    
    # Process tasks with sequential numbering
    count=0
    
    while IFS= read -r task; do
        if [ -z "$task" ]; then
            continue
        fi
        
        print_info "Processing: $task"
        
        # Extract task ID (e.g., 2025-CA-01 from 2025-CA-01_Robot_Assembly)
        task_id=$(echo "$task" | sed 's/_.*$//')
        
        # Increment count first (following original batch logic)
        ((count++))
        
        for lang in "${LANG_ARRAY[@]}"; do
            # Try to copy question file
            question_file="../$lang/${task_id}_${lang}.docx"
            if [ -f "$question_file" ]; then
                cp "$question_file" "$lang/${count}_${task}_${lang}.docx"
                print_info "  $lang: Copied question (${count})"
                
                # Increment for solution (if this is English)
                if [ "$lang" = "EN" ]; then
                    ((count++))
                    # Try to copy solution file
                    for soln_file in "../$lang/${task_id}-EN_Soln.docx" "../$lang/${task_id}-EN_SOLN.docx" "../$lang/${task_id}_EN_Soln.docx" "../$lang/${task_id}_EN_SOLN.docx"; do
                        if [ -f "$soln_file" ]; then
                            cp "$soln_file" "$lang/${count}_${task}_EN_SOLN.docx"
                            print_info "  $lang: Copied solution (${count})"
                            break
                        fi
                    done
                fi
            fi
        done
        
        # Increment count for next task iteration
        if [ "$lang" != "EN" ]; then
            ((count++))
        fi
        
    done < ../tasks.txt
    
    cd - > /dev/null
    print_success "File processing completed. Total files processed: $count"
}

# Function to display final instructions
show_final_instructions() {
    print_step "FINAL INSTRUCTIONS"
    echo ""
    print_success "🎉 Bebras document processing completed successfully!"
    echo ""
    print_info "📁 All processed files are in: $WORKING_DIR/Processed/"
    echo ""
    print_warning "📋 NEXT STEPS - Word Document Merge:"
    echo ""
    echo -e "${YELLOW}For macOS:${NC}"
    echo "1. Open the template file for your language (e.g., Bebras${YEAR}_questions_and_solutions_EN.docx)"
    echo "2. Open Finder and navigate to the Processed/[LANGUAGE]/ directory"
    echo "3. Select all numbered files (1_, 2_, 3_, etc.) - NOT the template file"
    echo "4. Drag and drop the selected files directly into the open Word document"
    echo "5. Word will automatically insert the content in numerical order"
    echo ""
    echo -e "${YELLOW}For Windows:${NC}"
    echo "1. Open the template file for your language (e.g., Bebras${YEAR}_questions_and_solutions_EN.docx)"
    echo "2. Click Insert → Object → Text from File"
    echo "3. Navigate to the Processed\\[LANGUAGE]\\ directory"
    echo "4. Multi-select all numbered files (Ctrl+click: 1_, 2_, 3_, etc.) - NOT the template file"
    echo "5. Click Insert to merge all files"
    echo ""
    print_warning "⚠️  IMPORTANT NOTES:"
    echo "• If Word stops mid-process, note the last inserted file number"
    echo "• Continue insertion from the next numbered file"
    echo "• Always verify the last solution appears in the merged document"
    echo "• DO NOT include the template file in the selection"
    echo ""
    
    IFS=',' read -ra LANG_ARRAY <<< "$LANGUAGES"
    for lang in "${LANG_ARRAY[@]}"; do
        file_count=$(ls "$WORKING_DIR/Processed/$lang/" 2>/dev/null | grep -E '^[0-9]+_' | wc -l)
        print_info "$lang: $file_count numbered files ready for merge"
    done
    
    echo ""
    print_success "🔒 Secret files (tasks, Excel, ZIP) remain secure and were not processed into the final output"
}

# Function to check for required files in current directory
check_required_files() {
    print_step "Checking for required files in current directory"
    echo ""
    
    print_info "📋 REQUIRED FILES CHECKLIST:"
    echo ""
    echo -e "${BLUE}The wizard needs these 3 files to process Bebras tasks:${NC}"
    echo ""
    echo -e "${YELLOW}1. 📊 Excel File${NC} - Contains task list in column O (starting from row 2)"
    echo -e "${YELLOW}2. 📦 ZIP File${NC} - Contains all task .docx files"
    echo -e "${YELLOW}3. 📄 Template File${NC} - Blank Word document template (.docx)"
    echo ""
    
    # Scan current directory for potential files
    print_info "🔍 Scanning current directory for matching files..."
    echo ""
    
    # Look for Excel files
    excel_files=(*.xlsx *.xls)
    if [ -f "${excel_files[0]}" ]; then
        print_success "Found Excel file(s):"
        for file in "${excel_files[@]}"; do
            if [ -f "$file" ]; then
                echo -e "  ${GREEN}✓${NC} $file"
            fi
        done
    else
        print_warning "No Excel files (.xlsx/.xls) found in current directory"
    fi
    echo ""
    
    # Look for ZIP files
    zip_files=(*.zip)
    if [ -f "${zip_files[0]}" ]; then
        print_success "Found ZIP file(s):"
        for file in "${zip_files[@]}"; do
            if [ -f "$file" ]; then
                echo -e "  ${GREEN}✓${NC} $file"
            fi
        done
    else
        print_warning "No ZIP files (.zip) found in current directory"
    fi
    echo ""
    
    # Look for DOCX template files
    template_files=(*.docx)
    template_count=0
    if [ -f "${template_files[0]}" ]; then
        print_success "Found Word template file(s):"
        for file in "${template_files[@]}"; do
            if [ -f "$file" ]; then
                # Skip files that look like task files
                if [[ ! "$file" =~ ^[0-9]{4}-[A-Z]{2}-[0-9] ]]; then
                    echo -e "  ${GREEN}✓${NC} $file"
                    ((template_count++))
                fi
            fi
        done
        if [ $template_count -eq 0 ]; then
            print_warning "No suitable template files found (only task files detected)"
        fi
    else
        print_warning "No Word document files (.docx) found in current directory"
    fi
    echo ""
    
    print_warning "⚠️  IMPORTANT NOTES:"
    echo "• Make sure all files are in the current directory: $(pwd)"
    echo "• File names can contain spaces - the wizard will handle them correctly"
    echo "• The Excel file should have task names in column O starting from row 2"
    echo "• The ZIP file should contain all .docx task files"
    echo "• The template file should be a blank Word document"
    echo ""
    
    # Ask user to confirm files are ready
    while true; do
        prompt_input "🚀 Are all required files present and ready to proceed? (y/N)" files_ready "N"
        if [[ "$files_ready" =~ ^[Yy] ]]; then
            print_success "User confirmed files are ready"
            break
        elif [[ "$files_ready" =~ ^[Nn]|^$ ]]; then
            print_error "Please ensure all required files are in the current directory before running the wizard"
            print_info "Current directory: $(pwd)"
            print_info "You can run 'ls -la *.xlsx *.zip *.docx' to check for files"
            exit 0
        else
            print_warning "Please answer 'y' for yes or 'n' for no"
        fi
    done
    
    echo ""
    print_success "✅ File check completed - proceeding with wizard"
    echo ""
}

# Main wizard function
run_wizard() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║           🦫 BEBRAS DOCUMENT PROCESSING WIZARD         ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Check for required files first
    check_required_files
    
    # Collect inputs
    print_step "Collecting Input Parameters"
    
    # Year
    while true; do
        prompt_input "📅 Enter the competition year (e.g., 2025)" YEAR "2025"
        if validate_year; then
            break
        fi
    done
    
    # Excel file
    while true; do
        prompt_input "📊 Enter path to Excel file (with task list in column O)" EXCEL_FILE
        if [ -n "$EXCEL_FILE" ] && validate_file_exists "$EXCEL_FILE" "Excel file"; then
            break
        fi
    done
    
    # ZIP file
    while true; do
        prompt_input "📦 Enter path to ZIP file (containing all task .docx files)" ZIP_FILE
        if [ -n "$ZIP_FILE" ] && validate_file_exists "$ZIP_FILE" "ZIP file"; then
            break
        fi
    done
    
    # Languages
    while true; do
        prompt_input "🌐 Enter target languages (comma-separated, e.g., EN,GU,MR) [EN,GU,MR,HI,BN,KA,OR,PA,TA,TE]" LANGUAGES "EN,GU,MR,HI,BN,KA,OR,PA,TA,TE"
        if validate_languages; then
            break
        fi
    done
    
    # Template file
    while true; do
        prompt_input "📄 Enter path to blank Word template file" TEMPLATE_FILE
        if [ -n "$TEMPLATE_FILE" ] && validate_file_exists "$TEMPLATE_FILE" "Template file"; then
            break
        fi
    done
    
    echo ""
    print_success "✅ All inputs validated successfully!"
    echo ""
    
    # Display configuration summary
    print_step "Configuration Summary"
    echo -e "${BLUE}Year:${NC} $YEAR"
    echo -e "${BLUE}Excel file:${NC} $EXCEL_FILE"
    echo -e "${BLUE}ZIP file:${NC} $ZIP_FILE"
    echo -e "${BLUE}Languages:${NC} $LANGUAGES"
    echo -e "${BLUE}Template:${NC} $TEMPLATE_FILE"
    echo ""
    
    # Confirm before proceeding
    prompt_input "🚀 Proceed with processing? (y/N)" confirm "N"
    if [[ ! "$confirm" =~ ^[Yy] ]]; then
        print_info "Processing cancelled by user"
        exit 0
    fi
    
    # Execute processing steps
    setup_working_directory
    extract_tasks
    extract_and_organize_files
    organize_by_language
    process_and_number_files
    show_final_instructions
}

# Error handling
trap 'print_error "Script interrupted! Cleaning up..."; exit 1' INT TERM

# Check prerequisites
print_info "Checking prerequisites..."

if ! command -v python3 >/dev/null 2>&1; then
    print_error "Python 3 is required but not installed"
    exit 1
fi

if ! command -v unzip >/dev/null 2>&1; then
    print_error "unzip command is required but not installed"
    exit 1
fi

print_success "Prerequisites check passed"

# Run the wizard
run_wizard