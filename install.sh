#!/bin/bash
# ACS CLI Installer for Unix (macOS/Linux)
# Run with: curl -sSL https://raw.githubusercontent.com/Alaa-Taieb/asc-cli/main/install.sh | bash

set -e

echo ""
echo "  Installing ACS CLI..."
echo ""

# Install the package
if pip install acs-cli --quiet 2>/dev/null; then
    echo "  ✓ Package installed"
else
    echo "  ✗ Failed to install package"
    exit 1
fi

# Verify installation
if command -v acs &> /dev/null; then
    echo "  ✓ 'acs' command available"
else
    echo ""
    echo "  ⚠ 'acs' command not found in PATH"
    echo "  You may need to add Python's bin directory to your PATH."
    echo "  Try: export PATH=\"\$PATH:\$(python -m site --user-base)/bin\""
fi

echo ""
echo "  Installation complete!"
echo "  Run 'acs init' in any project to get started."
echo ""
