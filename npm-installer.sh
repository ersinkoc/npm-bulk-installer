#!/bin/bash

# NPM Bulk Installer - Linux/Mac Version
# Author: Ersin KOÇ
# Date: 2025-08-17
# Description: Finds all package.json files and runs npm install

# Default values
START_PATH="${1:-$(pwd)}"
LOG_FILE="${2:-npm-install-log.txt}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Initialize log file
LOG_PATH="$START_PATH/$LOG_FILE"
echo "NPM Installation Log - $(date)" > "$LOG_PATH"

# Welcome message
echo -e "\n${CYAN}========================================${NC}"
echo -e "${YELLOW}    NPM Bulk Installer (Bash)${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "Start directory: $START_PATH"
echo -e "Log file: $LOG_PATH"

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}npm is not installed or not in PATH!${NC}"
    exit 1
fi

echo -e "${GREEN}npm version: $(npm --version)${NC}"

# Find package.json files (excluding node_modules)
echo -e "\n${YELLOW}Searching for package.json files...${NC}"
mapfile -t PACKAGE_FILES < <(find "$START_PATH" -name "package.json" -not -path "*/node_modules/*" 2>/dev/null)

if [ ${#PACKAGE_FILES[@]} -eq 0 ]; then
    echo -e "${RED}No package.json files found!${NC}"
    exit 1
fi

echo -e "${GREEN}Found ${#PACKAGE_FILES[@]} package.json files${NC}"

# List directories
echo -e "\n${CYAN}Directories to process:${NC}"
for i in "${!PACKAGE_FILES[@]}"; do
    DIR=$(dirname "${PACKAGE_FILES[$i]}")
    REL_PATH="${DIR#$START_PATH/}"
    [ "$REL_PATH" = "$DIR" ] && REL_PATH="."
    echo -e "  [$((i+1))] $REL_PATH"
done

# Confirmation
read -p $'\nProceed with npm install? (Y/N): ' -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Operation cancelled.${NC}"
    exit 0
fi

# Process each directory
SUCCESS_COUNT=0
ERROR_COUNT=0

echo -e "\n${GREEN}Starting npm install operations...${NC}"
echo -e "${CYAN}========================================${NC}"

for i in "${!PACKAGE_FILES[@]}"; do
    DIR=$(dirname "${PACKAGE_FILES[$i]}")
    REL_PATH="${DIR#$START_PATH/}"
    [ "$REL_PATH" = "$DIR" ] && REL_PATH="."
    
    echo -e "\n${YELLOW}[$((i+1))/${#PACKAGE_FILES[@]}] $REL_PATH${NC}"
    
    # Log to file
    echo -e "\n----------------------------------------" >> "$LOG_PATH"
    echo "Directory: $REL_PATH" >> "$LOG_PATH"
    echo "Time: $(date '+%H:%M:%S')" >> "$LOG_PATH"
    
    # Change to directory and run npm install
    cd "$DIR" || continue
    
    echo -e "  Running npm install..."
    
    # Run npm install and capture output
    if OUTPUT=$(npm install 2>&1); then
        ((SUCCESS_COUNT++))
        echo -e "  ${GREEN}[OK] Success!${NC}"
        echo "Status: SUCCESS" >> "$LOG_PATH"
    else
        ((ERROR_COUNT++))
        echo -e "  ${RED}[X] Failed!${NC}"
        echo "Status: FAILED" >> "$LOG_PATH"
        echo "$OUTPUT" >> "$LOG_PATH"
    fi
done

# Return to original directory
cd "$START_PATH" || exit

# Summary
echo -e "\n${CYAN}========================================${NC}"
echo -e "${YELLOW}         SUMMARY${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "Total packages: ${#PACKAGE_FILES[@]}"
echo -e "${GREEN}Successful: $SUCCESS_COUNT${NC}"
echo -e "${RED}Failed: $ERROR_COUNT${NC}"

echo -e "\n${YELLOW}Log file saved to: $LOG_PATH${NC}"

# Exit code
if [ $ERROR_COUNT -gt 0 ]; then
    exit 1
else
    echo -e "\n${GREEN}All packages installed successfully!${NC}"
    exit 0
fi