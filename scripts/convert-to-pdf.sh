#!/bin/bash
#
# convert-to-pdf.sh
# Converts all Markdown files to PDF using pandoc
# Skips any directories named "orig"
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Default to parent of script directory (specifications root)
ROOT_DIR="${1:-$(dirname "$SCRIPT_DIR")}"

echo -e "${GREEN}Converting Markdown files to PDF...${NC}"
echo "Root directory: $ROOT_DIR"
echo ""

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo -e "${RED}Error: pandoc is not installed.${NC}"
    echo "Please install pandoc first. See README.md for installation instructions."
    exit 1
fi

# Check if a PDF engine is available
PDF_ENGINE=""
if command -v xelatex &> /dev/null; then
    PDF_ENGINE="xelatex"
elif command -v pdflatex &> /dev/null; then
    PDF_ENGINE="pdflatex"
elif command -v wkhtmltopdf &> /dev/null; then
    PDF_ENGINE="wkhtmltopdf"
fi

if [ -z "$PDF_ENGINE" ]; then
    echo -e "${YELLOW}Warning: No PDF engine found (xelatex, pdflatex, or wkhtmltopdf).${NC}"
    echo "Attempting conversion with default pandoc settings..."
    echo ""
fi

# Counter for converted files
converted=0
failed=0

# Find all markdown files, excluding "orig" directories
while IFS= read -r -d '' md_file; do
    # Get the directory and filename
    dir=$(dirname "$md_file")
    filename=$(basename "$md_file" .md)
    pdf_file="${dir}/${filename}.pdf"

    echo -n "Converting: $md_file ... "

    # Run pandoc conversion
    if [ -n "$PDF_ENGINE" ]; then
        if pandoc "$md_file" -o "$pdf_file" --pdf-engine="$PDF_ENGINE" 2>/dev/null; then
            echo -e "${GREEN}OK${NC}"
            ((converted++))
        else
            echo -e "${RED}FAILED${NC}"
            ((failed++))
        fi
    else
        if pandoc "$md_file" -o "$pdf_file" 2>/dev/null; then
            echo -e "${GREEN}OK${NC}"
            ((converted++))
        else
            echo -e "${RED}FAILED${NC}"
            ((failed++))
        fi
    fi
done < <(find "$ROOT_DIR" -type d -name "orig" -prune -o -type f -name "*.md" -print0)

echo ""
echo "----------------------------------------"
echo -e "Conversion complete: ${GREEN}${converted} succeeded${NC}, ${RED}${failed} failed${NC}"

if [ $failed -gt 0 ]; then
    echo -e "${YELLOW}Some conversions failed. Ensure you have a LaTeX distribution installed.${NC}"
    exit 1
fi
