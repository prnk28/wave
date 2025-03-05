#!/bin/bash

set -e

BREW_INSTALLED=$(command -v brew)
GO_INSTALLED=$(command -v go)

function checkInstall() {
  executable=$1
  if ! [ -x "$(command -v $executable)" ]; then
    echo "$executable not installed. Please install $executable and try again."
    return 1
  fi
  return 0
}


function downloadRemoteTemplate() {
  filename=$1
  url=https://raw.githubusercontent.com/prnk28/gh-pm/refs/heads/main/assets/templates/$filename
  curl -sSL $url -o $TEMPLATES_DIR/$filename
}

# Check if required tools are installed
GH_INSTALLED=$(checkInstall gh)
GUM_INSTALLED=$(checkInstall gum)
FZF_INSTALLED=$(checkInstall fzf)
TASKFILE_INSTALLED=$(checkInstall task)

TEMPLATES_DIR=~/.local/share/wave/templates
rm -rf $TEMPLATES_DIR

function checkTemplates() {
  # Test for if ~/.local/share/wave/templates exists
  if [ ! -d "$TEMPLATES_DIR" ]; then
    mkdir -p $TEMPLATES_DIR
  fi

  # Download the required templates
  downloadRemoteTemplate Taskfile.bun.yml
  downloadRemoteTemplate Taskfile.pkl.yml
  downloadRemoteTemplate Taskfile.docker.yml
  downloadRemoteTemplate Taskfile.go.yml
  downloadRemoteTemplate Taskfile.log.yml
}

checkTemplates

ROOT_DIR=$(git rev-parse --show-toplevel)
cd $ROOT_DIR

# Define the taskfile content
taskfile=$(cat <<'EOF'
version: '3'
silent: true
includes:
  bun: ~/.local/share/wave/templates/Taskfile.bun.yml
  conv: ~/.local/share/wave/templates/Taskfile.pkl.yml
  docker: ~/.local/share/wave/templates/Taskfile.docker.yml
  go: ~/.local/share/wave/templates/Taskfile.go.yml
  log: ~/.local/share/wave/templates/Taskfile.log.yml
  dev: 
    taskfile: .taskfiles/Dev.yml
    flatten: true
    dir: .
tasks:
  default:
    cmds:
      - task -l
    silent: true
EOF
)

# Check if an argument was provided
if [ $# -gt 0 ]; then
    # Run task with the provided argument
    echo "$taskfile" | task -t - "$@"
else
    # Run task without arguments (default behavior)
    echo "$taskfile" | task -t -
fi
