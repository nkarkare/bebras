#!/bin/bash

# Remove existing language folders if present
rm -rf "/Users/apple/code/bebras/2025/GU"
rm -rf "/Users/apple/code/bebras/2025/EN"
rm -rf "/Users/apple/code/bebras/2025/KA"
rm -rf "/Users/apple/code/bebras/2025/MR"
rm -rf "/Users/apple/code/bebras/2025/OR"
rm -rf "/Users/apple/code/bebras/2025/TA"
rm -rf "/Users/apple/code/bebras/2025/TE"
rm -rf "/Users/apple/code/bebras/2025/HI"
rm -rf "/Users/apple/code/bebras/2025/BN"
rm -rf "/Users/apple/code/bebras/2025/PA"

# Create language directories
mkdir -p "/Users/apple/code/bebras/2025/GU"
mkdir -p "/Users/apple/code/bebras/2025/EN"
mkdir -p "/Users/apple/code/bebras/2025/KA"
mkdir -p "/Users/apple/code/bebras/2025/MR"
mkdir -p "/Users/apple/code/bebras/2025/OR"
mkdir -p "/Users/apple/code/bebras/2025/TA"
mkdir -p "/Users/apple/code/bebras/2025/TE"
mkdir -p "/Users/apple/code/bebras/2025/HI"
mkdir -p "/Users/apple/code/bebras/2025/BN"
mkdir -p "/Users/apple/code/bebras/2025/PA"

# Copy files from tasks directory (run this from the tasks directory)
cd tasks

# Copy GU files
find . -iname "*GU.docx" -exec cp {} "/Users/apple/code/bebras/2025/GU/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/GU/" \;

# Copy EN files
find . -iname "*EN.docx" -exec cp {} "/Users/apple/code/bebras/2025/EN/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/EN/" \;

# Copy KA files
find . -iname "*KA.docx" -exec cp {} "/Users/apple/code/bebras/2025/KA/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/KA/" \;

# Copy MR files
find . -iname "*MR.docx" -exec cp {} "/Users/apple/code/bebras/2025/MR/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/MR/" \;

# Copy OR files
find . -iname "*OR.docx" -exec cp {} "/Users/apple/code/bebras/2025/OR/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/OR/" \;

# Copy TA files
find . -iname "*TA.docx" -exec cp {} "/Users/apple/code/bebras/2025/TA/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/TA/" \;

# Copy TE files
find . -iname "*TE.docx" -exec cp {} "/Users/apple/code/bebras/2025/TE/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/TE/" \;

# Copy HI files
find . -iname "*HI.docx" -exec cp {} "/Users/apple/code/bebras/2025/HI/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/HI/" \;

# Copy BN files
find . -iname "*BN.docx" -exec cp {} "/Users/apple/code/bebras/2025/BN/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/BN/" \;

# Copy PA files
find . -iname "*PA.docx" -exec cp {} "/Users/apple/code/bebras/2025/PA/" \;
find . -iname "*EN_[Ss][Oo][Ll][Nn].docx" -exec cp {} "/Users/apple/code/bebras/2025/PA/" \;

echo "Files organized successfully!"