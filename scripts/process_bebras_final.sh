#!/bin/bash

# Remove existing processed folder and recreate
echo "Removing existing Processed folder and recreating..."
rm -rf "/Users/apple/code/bebras/2025/Processed"
mkdir -p "/Users/apple/code/bebras/2025/Processed"
cd "/Users/apple/code/bebras/2025/Processed"

# Create language directories
mkdir -p EN MR GU KA TA OR TE HI BN PA

echo "Created language directories in Processed folder"

# Check if template file exists before proceeding
template_file="/Users/apple/code/bebras/2025/Bebras_questions_and_solutions_empty.docx"
if [ ! -f "$template_file" ]; then
    echo "ERROR: Template file not found: $template_file"
    echo "Please ensure Bebras_questions_and_solutions_empty.docx exists in the project root directory"
    echo "Script cannot continue without the template file."
    exit 1
fi

# Copy blank template to each language directory
echo "Copying blank templates..."
cp "$template_file" "EN/Bebras2025_questions_and_solutions_EN.docx"
cp "$template_file" "GU/Bebras2025_questions_and_solutions_GU.docx"
cp "$template_file" "MR/Bebras2025_questions_and_solutions_MR.docx"
cp "$template_file" "KA/Bebras2025_questions_and_solutions_KA.docx"
cp "$template_file" "TA/Bebras2025_questions_and_solutions_TA.docx"
cp "$template_file" "OR/Bebras2025_questions_and_solutions_OR.docx"
cp "$template_file" "TE/Bebras2025_questions_and_solutions_TE.docx"
cp "$template_file" "BN/Bebras2025_questions_and_solutions_BN.docx"
cp "$template_file" "PA/Bebras2025_questions_and_solutions_PA.docx"
cp "$template_file" "HI/Bebras2025_questions_and_solutions_HI.docx"
echo "Copied blank templates to all language directories"

# Process tasks from tasks.txt
echo "Processing tasks from tasks.txt..."
count=0

if [ ! -f "/Users/apple/code/bebras/2025/tasks.txt" ]; then
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
    
    # Increment count first (as in original batch logic)
    ((count++))
    
    # Process EN first
    echo "Copying EN..."
    if cp "/Users/apple/code/bebras/2025/EN/${task_id}_EN.docx" "/Users/apple/code/bebras/2025/Processed/EN/${count}_${task}_EN.docx" 2>/dev/null; then
        # Question file copied successfully, now increment count and copy solution
        ((count++))
        echo "Copying solutions to EN..."
        for soln_file in "/Users/apple/code/bebras/2025/EN/${task_id}-EN_Soln.docx" "/Users/apple/code/bebras/2025/EN/${task_id}-EN_SOLN.docx"; do
            if [ -f "$soln_file" ]; then
                cp "$soln_file" "/Users/apple/code/bebras/2025/Processed/EN/${count}_${task}_EN_SOLN.docx"
                break
            fi
        done
    fi
    
    # Process BN
    echo "Copying BN..."
    if cp "/Users/apple/code/bebras/2025/BN/${task_id}_BN.docx" "/Users/apple/code/bebras/2025/Processed/BN/${count}_${task}_BN.docx" 2>/dev/null; then
        ((count++))
    fi
    
    # Process PA
    echo "Copying PA..."
    if cp "/Users/apple/code/bebras/2025/PA/${task_id}_PA.docx" "/Users/apple/code/bebras/2025/Processed/PA/${count}_${task}_PA.docx" 2>/dev/null; then
        ((count++))
    fi
    
    # Process HI
    echo "Copying HI..."
    if cp "/Users/apple/code/bebras/2025/HI/${task_id}_HI.docx" "/Users/apple/code/bebras/2025/Processed/HI/${count}_${task}_HI.docx" 2>/dev/null; then
        ((count++))
    fi
    
    # Process MR
    echo "Copying MR..."
    if cp "/Users/apple/code/bebras/2025/MR/${task_id}_MR.docx" "/Users/apple/code/bebras/2025/Processed/MR/${count}_${task}_MR.docx" 2>/dev/null; then
        ((count++))
    fi
    
    # Process GU
    echo "Copying GU..."
    if cp "/Users/apple/code/bebras/2025/GU/${task_id}_GU.docx" "/Users/apple/code/bebras/2025/Processed/GU/${count}_${task}_GU.docx" 2>/dev/null; then
        ((count++))
    fi
    
    # Process KA
    echo "Copying KA..."
    if cp "/Users/apple/code/bebras/2025/KA/${task_id}_KA.docx" "/Users/apple/code/bebras/2025/Processed/KA/${count}_${task}_KA.docx" 2>/dev/null; then
        ((count++))
    fi
    
    # Process OR
    echo "Copying OR..."
    if cp "/Users/apple/code/bebras/2025/OR/${task_id}_OR.docx" "/Users/apple/code/bebras/2025/Processed/OR/${count}_${task}_OR.docx" 2>/dev/null; then
        ((count++))
    fi
    
    # Process TA
    echo "Copying TA..."
    if cp "/Users/apple/code/bebras/2025/TA/${task_id}_TA.docx" "/Users/apple/code/bebras/2025/Processed/TA/${count}_${task}_TA.docx" 2>/dev/null; then
        ((count++))
    fi
    
    # Process TE
    echo "Copying TE..."
    if cp "/Users/apple/code/bebras/2025/TE/${task_id}_TE.docx" "/Users/apple/code/bebras/2025/Processed/TE/${count}_${task}_TE.docx" 2>/dev/null; then
        ((count++))
    fi
    
    echo "***DONE Processing for $task***"
    echo ""
    echo ""
    
done < "/Users/apple/code/bebras/2025/tasks.txt"

echo "Processing complete! Total files processed: $count"