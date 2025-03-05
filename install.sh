#!/bin/bash

set -e

CLEAN=0
GIT_URL="https://github.com/prnk28/wave.git"
WAVE_DIR="$HOME/.local/share/wave"

function freshClone() {
    rm -rf "$WAVE_DIR"
    git clone "$GIT_URL" "$WAVE_DIR"
    cd "$WAVE_DIR"
    chmod +x "./bin/wave"
    mv ./bin/wave ~/.local/bin
}

if [ CLEAN -eq 1 ]; then
    freshClone
else
    cd "$WAVE_DIR"
    git pull
fi
