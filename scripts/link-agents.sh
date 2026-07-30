#!/usr/bin/env bash
# MindForge · link-agents.sh
# Create/update symlinks so every detected Agent CLI points at the global install.
set -euo pipefail

GLOBAL_ROOT="${MINDFORGE_HOME:-$HOME/.agents/skills/MindForge}"
DISTILLED_ROOT="${MINDFORGE_DISTILLED:-$HOME/.agents/skills/distilled}"

# Must be able to read the engine (follow one level of symlink)
skill_readable() {
  local base="$1"
  [[ -f "$base/SKILL.md" ]] || [[ -f "$(readlink "$base" 2>/dev/null || true)/SKILL.md" ]]
}

if ! skill_readable "$GLOBAL_ROOT"; then
  echo "❌ MindForge engine not readable at: $GLOBAL_ROOT"
  echo "   Run install first: bash scripts/install.sh --force"
  exit 1
fi

mkdir -p "$DISTILLED_ROOT"

# tool_name|skill_dir|also_link_distilled (1/0)
CANDIDATES=(
  "Claude Code|$HOME/.claude/skills|1"
  "Grok Build|$HOME/.grok/skills|1"
  "Codex|$HOME/.codex/skills|1"
  "Gemini CLI|$HOME/.gemini/skills|1"
  "OpenCode|$HOME/.opencode/skills|1"
  "Cursor (agents)|$HOME/.cursor/skills|1"
  "Windsurf|$HOME/.codeium/windsurf/skills|1"
)

link_engine() {
  local name="$1"
  local dir="$2"
  local target="$dir/MindForge"

  # Never link a path onto itself (global install lives here)
  if [[ "$target" == "$GLOBAL_ROOT" ]]; then
    echo "  ✓ $name  global root — skip self-link"
    return 0
  fi

  mkdir -p "$dir"

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target" 2>/dev/null || true)"
    if [[ "$current" == "$GLOBAL_ROOT" ]] && skill_readable "$target"; then
      echo "  ✓ $name  already linked → $target"
      return 0
    fi
    # Wrong target or broken (self-loop etc.)
    rm -f "$target"
    ln -sfn "$GLOBAL_ROOT" "$target"
    echo "  ↻ $name  relinked → $target"
  elif [[ -e "$target" ]]; then
    if skill_readable "$target"; then
      echo "  ✓ $name  present → $target"
    else
      echo "  ⚠ $name  $target exists and is not a usable MindForge — skip"
    fi
  else
    ln -sfn "$GLOBAL_ROOT" "$target"
    echo "  + $name  linked → $target"
  fi
}

link_distilled() {
  local name="$1"
  local dir="$2"
  local dtarget="$dir/distilled"

  if [[ "$dtarget" == "$DISTILLED_ROOT" ]]; then
    return 0
  fi

  mkdir -p "$dir"

  if [[ -L "$dtarget" ]]; then
    local current
    current="$(readlink "$dtarget" 2>/dev/null || true)"
    if [[ "$current" == "$DISTILLED_ROOT" ]]; then
      return 0
    fi
    rm -f "$dtarget"
    ln -sfn "$DISTILLED_ROOT" "$dtarget"
    echo "    ↻ distilled relinked → $dtarget"
  elif [[ ! -e "$dtarget" ]]; then
    ln -sfn "$DISTILLED_ROOT" "$dtarget"
    echo "    + distilled linked → $dtarget"
  fi
}

echo "🔗 MindForge · linking agents"
echo "   Global:    $GLOBAL_ROOT"
echo "   Distilled: $DISTILLED_ROOT"
echo ""

linked=0
for entry in "${CANDIDATES[@]}"; do
  IFS='|' read -r name dir link_d <<< "$entry"
  parent="$(dirname "$dir")"
  if [[ ! -d "$parent" ]]; then
    echo "  · $name  not detected ($parent missing) — skip"
    continue
  fi
  link_engine "$name" "$dir"
  if [[ "$link_d" == "1" ]]; then
    link_distilled "$name" "$dir"
  fi
  linked=$((linked + 1))
done

# Ensure global agents tree has engine + distilled (install owns engine path)
if [[ -d "$HOME/.agents" ]]; then
  mkdir -p "$HOME/.agents/skills"
  if skill_readable "$GLOBAL_ROOT"; then
    echo "  ✓ Agents (global)  engine OK → $GLOBAL_ROOT"
  fi
  if [[ ! -e "$HOME/.agents/skills/distilled" ]]; then
    ln -sfn "$DISTILLED_ROOT" "$HOME/.agents/skills/distilled" 2>/dev/null \
      || mkdir -p "$HOME/.agents/skills/distilled"
  fi
fi

echo ""
echo "Done. Linked/checked $linked tool path(s)."
echo "Tip: re-run anytime after installing a new Agent CLI."
