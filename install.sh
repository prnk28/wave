#!/bin/bash

set -e

CLEAN=0
WAVE_DIR="$HOME/.local/share/wave"

function freshClone() {
    rm -rf "$WAVE_DIR"
    cd ~/.local/share
    gh repo clone prnk28/wave
    cd "$WAVE_DIR"
    chmod +x "./bin/wave"
    mv ./bin/wave ~/.local/bin
}

if [ CLEAN == 1 ]; then
    freshClone
else
    cd "$WAVE_DIR"
    git pull
fi
