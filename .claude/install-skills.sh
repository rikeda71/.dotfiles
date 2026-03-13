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

link_local_skill() {
  local skill_name="$1"
  local source="$HOME/.dotfiles/.claude/skills/$skill_name"
  local target="$SKILLS_DIR/$skill_name"

  if [ ! -d "$source" ]; then
    echo "[$skill_name] source not found: $source"
    return
  fi

  if [ -L "$target" ]; then
    echo "[$skill_name] already linked, skipping"
    return
  fi

  mkdir -p "$SKILLS_DIR"
  ln -s "$source" "$target"
  echo "[$skill_name] linked"
}

echo "Installing Claude Code skills..."

install_skill "vercel-react-best-practices"
install_skill "web-design-guidelines"

echo ""
echo "Linking local skills..."

link_local_skill "commit"
link_local_skill "cleanup-worktrees"
link_local_skill "pr"
link_local_skill "review"
link_local_skill "pr-review-address"

echo ""
echo "Done."
