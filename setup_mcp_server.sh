#!/usr/bin/env bash
# Setup script for Kali Linux MCP Server

set -e  # Exit on error
set -o pipefail

echo "Setting up Kali Linux MCP Server..."
echo ""

# Ensure 'python3' is installed
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ Error: Python 3 is not installed."
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
PYTHON_MAJOR=$(echo "$PYTHON_VERSION" | cut -d. -f1)
PYTHON_MINOR=$(echo "$PYTHON_VERSION" | cut -d. -f2)

if [ "$PYTHON_MAJOR" -lt 3 ] || { [ "$PYTHON_MAJOR" -eq 3 ] && [ "$PYTHON_MINOR" -lt 8 ]; }; then
    echo "❌ Error: Python 3.8 or higher is required."
    echo "Current version: $PYTHON_VERSION"
    exit 1
fi

echo "✅ Python version $PYTHON_VERSION detected"

# Check if venv module is available
if ! python3 -m venv --help > /dev/null 2>&1; then
    echo "❌ Error: Python 'venv' module is not available."
    echo "Install it with:"
    echo "sudo apt install python3-venv"
    exit 1
fi

# Check if ensurepip is available
if ! python3 -m ensurepip --version > /dev/null 2>&1; then
    echo "❌ Error: Python 'ensurepip' module is not available."
    echo "You likely need to install the venv package for your Python version:"
    echo ""
    echo "  sudo apt install python3.${PYTHON_MINOR}-venv"
    echo ""
    echo "Then re-run this script."
    exit 1
fi

# Remove existing virtual environment if needed
if [ -d venv ]; then
    echo "🔄 Removing existing virtual environment..."
    rm -rf venv
fi

# Create virtual environment
echo "🔧 Creating virtual environment..."
python3 -m venv venv

# Check if venv created correctly
if [ ! -f venv/bin/activate ]; then
    echo "❌ Error: Virtual environment creation failed."
    exit 1
fi

# Activate virtual environment
echo "🧪 Activating virtual environment..."
# shellcheck source=/dev/null
source venv/bin/activate

# Check for requirements.txt
if [ ! -f requirements.txt ]; then
    echo "❌ Error: requirements.txt not found!"
    deactivate
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies from requirements.txt..."
pip install --upgrade pip
pip install -r requirements.txt

# Make script files executable if they exist
echo "🔐 Making script files executable..."
for script in mcp_server.py kali_api_server.py run.py; do
    if [ -f "$script" ]; then
        chmod +x "$script"
        echo "  ✔ $script made executable"
    else
        echo "  ⚠ $script not found, skipping"
    fi
done

# Done
echo ""
echo "✅ Setup complete!"
echo ""
echo "To run the servers, use:"
echo "  ./run.py"
echo ""
echo "For more options:"
echo "  ./run.py --help"
echo ""
echo "To start Claude for Desktop with the MCP server:"
echo "  1. Open Claude for Desktop"
echo "  2. Configure it to use the MCP server at http://localhost:8080"
echo "  3. Start a new conversation"
echo ""
