#!/bin/zsh
# Install Claude Code skills from anthropics/skills marketplace
# Run: zsh ~/.dotfiles/.claude/install-skills.sh

set -e

SKILLS_DIR="$HOME/.claude/skills"
SKILLS_REPO="https://github.com/anthropics/skills.git"

install_skill() {
  local skill_name="$1"
  local target="$SKILLS_DIR/$skill_name"

  if [ -d "$target" ]; then
    echo "[$skill_name] already installed, skipping"
    return
  fi

  echo "[$skill_name] installing..."
  local tmp
  tmp=$(mktemp -d)
  git clone --depth=1 --filter=blob:none --sparse "$SKILLS_REPO" "$tmp" 2>/dev/null
  git -C "$tmp" sparse-checkout set "$skill_name" 2>/dev/null
  mkdir -p "$SKILLS_DIR"
  cp -r "$tmp/$skill_name" "$target"
  rm -rf "$tmp"
  echo "[$skill_name] installed"
}

echo "Installing Claude Code skills..."

install_skill "vercel-react-best-practices"
install_skill "web-design-guidelines"

echo ""
echo "Done."
