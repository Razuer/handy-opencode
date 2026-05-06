#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
OPENCODE_DIR=${OPENCODE_DIR:-"$HOME/.config/opencode"}
SKILLS_SRC="$SCRIPT_DIR/skills"
AGENTS_SRC="$SCRIPT_DIR/agents"
COMMANDS_SRC="$SCRIPT_DIR/commands"
SKILLS_DST="$OPENCODE_DIR/skills"
AGENTS_DST="$OPENCODE_DIR/agents"
COMMANDS_DST="$OPENCODE_DIR/commands"

install_skills=false
install_agents=false
install_commands=false
force=false

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Install handy-opencode skills, agents, and commands into your OpenCode config.

Options:
  --skills     Install skills only
  --agents     Install agents only
  --commands   Install commands only
  --all        Install skills, agents, and commands
  --force      Replace existing targets
  --help       Show this help text

If no install target is provided, the script runs in interactive mode.
EOF
}

prompt_choice() {
  printf 'Select what to install:\n'
  printf '  1) Skills only\n'
  printf '  2) Agents only\n'
  printf '  3) Commands only\n'
  printf '  4) Skills, agents, and commands\n'
  printf 'Choice [1-4]: '
  read -r choice

  case "$choice" in
    1)
      install_skills=true
      ;;
    2)
      install_agents=true
      ;;
    3)
      install_commands=true
      ;;
    4)
      install_skills=true
      install_agents=true
      install_commands=true
      ;;
    *)
      printf 'Invalid choice: %s\n' "$choice" >&2
      exit 1
      ;;
  esac
}

ensure_dir() {
  local dir=$1
  mkdir -p "$dir"
}

link_directory_contents() {
  local src_dir=$1
  local dst_dir=$2
  local label=$3

  if [[ ! -d "$src_dir" ]]; then
    printf 'Skipping %s: source directory not found at %s\n' "$label" "$src_dir"
    return
  fi

  ensure_dir "$dst_dir"

  local installed=0
  local skipped=0

  shopt -s nullglob
  for src in "$src_dir"/*; do
    local name target
    name=$(basename "$src")
    target="$dst_dir/$name"

    if [[ -e "$target" || -L "$target" ]]; then
      if [[ "$force" == true ]]; then
        rm -rf "$target"
      else
        printf 'Skipping existing %s: %s\n' "$label" "$target"
        skipped=$((skipped + 1))
        continue
      fi
    fi

    ln -s "$src" "$target"
    printf 'Linked %s: %s -> %s\n' "$label" "$target" "$src"
    installed=$((installed + 1))
  done
  shopt -u nullglob

  printf '%s complete: %d installed, %d skipped\n' "$label" "$installed" "$skipped"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skills)
      install_skills=true
      ;;
    --agents)
      install_agents=true
      ;;
    --commands)
      install_commands=true
      ;;
    --all)
      install_skills=true
      install_agents=true
      install_commands=true
      ;;
    --force)
      force=true
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ "$install_skills" == false && "$install_agents" == false && "$install_commands" == false ]]; then
  prompt_choice
fi

printf 'Installing into %s\n' "$OPENCODE_DIR"

if [[ "$install_skills" == true ]]; then
  link_directory_contents "$SKILLS_SRC" "$SKILLS_DST" "skills"
fi

if [[ "$install_agents" == true ]]; then
  link_directory_contents "$AGENTS_SRC" "$AGENTS_DST" "agents"
fi

if [[ "$install_commands" == true ]]; then
  link_directory_contents "$COMMANDS_SRC" "$COMMANDS_DST" "commands"
fi

printf 'Done.\n'
