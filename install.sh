#!/bin/bash

set -e

CLEAN=0
WAVE_DIR="$HOME/.local/share/wave"

function freshClone() {
    rm -rf "$WAVE_DIR"
    mkdir -p ~/.local/share
    cd ~/.local/share
    
    # Check if gh CLI is installed
    if ! command -v gh &> /dev/null; then
        echo "GitHub CLI (gh) is not installed. Installing using alternative method..."
        git clone https://github.com/prnk28/wave.git
    else
        gh repo clone prnk28/wave
    fi
    
    cd "$WAVE_DIR"
    
    # Create bin directory if it doesn't exist
    mkdir -p ~/.local/bin
    
    # Make wave executable and move it
    chmod +x "./bin/wave"
    cp ./bin/wave ~/.local/bin/
    
    echo "Wave installed successfully to ~/.local/bin/wave"
}

# Check if this is being run via curl
if [ "$0" = "bash" ] || [ "${0##*/}" = "bash" ]; then
    CLEAN=1
fi

# Create directories if they don't exist
mkdir -p ~/.local/bin
mkdir -p ~/.local/share

if [ "$CLEAN" -eq 1 ]; then
    freshClone
else
    # Check if wave directory exists
    if [ ! -d "$WAVE_DIR" ]; then
        echo "Wave directory not found. Performing fresh installation..."
        freshClone
    else
        cd "$WAVE_DIR"
        git pull
        
        # Make sure wave is executable and in path
        chmod +x "./bin/wave"
        cp ./bin/wave ~/.local/bin/
        
        echo "Wave updated successfully"
    fi
fi

# Add to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc 2>/dev/null || true
    echo "Added ~/.local/bin to PATH. Please restart your shell or run 'source ~/.bashrc' to use wave."
fi

echo "Installation complete. Run 'wave' to get started."
