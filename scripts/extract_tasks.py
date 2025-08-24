#!/usr/bin/env python3
"""
Script to extract task names from Bebras India 2025 tasks Excel file
Extracts values from column O starting from row 2 and saves to tasks.txt
"""

import pandas as pd
import sys
import os

def extract_tasks():
    """Extract tasks from Excel file O2:O column and save to tasks.txt"""
    
    # Path to the Excel file
    excel_file = "/Users/apple/code/bebras/2025/Bebras India 2025 tasks .xlsx"
    
    if not os.path.exists(excel_file):
        print(f"Error: Excel file not found at {excel_file}")
        return False
    
    try:
        # Read the Excel file
        print(f"Reading Excel file: {excel_file}")
        df = pd.read_excel(excel_file)
        
        # Get column O (index 14, since A=0, B=1, ..., O=14)
        # Extract values from row 2 onwards (index 1 onwards since pandas is 0-indexed)
        if len(df.columns) <= 14:
            print(f"Error: Excel file doesn't have column O (only {len(df.columns)} columns)")
            return False
        
        column_o = df.iloc[:, 14]  # Column O (15th column, 0-indexed)
        
        # Filter out NaN values and blank strings, extract from row 2 onwards (index 1)
        tasks = column_o[1:].dropna().astype(str).str.strip()
        tasks = [task for task in tasks if task and task != '' and task != 'nan' and task != '_']
        
        if not tasks:
            print("No tasks found in column O starting from row 2")
            return False
        
        # Save to tasks.txt
        output_file = "/Users/apple/code/bebras/2025/tasks.txt"
        with open(output_file, 'w', encoding='utf-8') as f:
            for task in tasks:
                f.write(f"{task}\n")
        
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