#!/usr/bin/env bash
# MindForge · install.sh
# Install MindForge to ~/.agents/skills/MindForge and symlink into detected Agent CLIs.
#
# Usage:
#   bash scripts/install.sh              # install from this repo
#   bash scripts/install.sh --force      # overwrite existing install
#   curl -fsSL <url>/scripts/install.sh | bash   # remote install (clones repo)
set -euo pipefail

FORCE=0
SOURCE_DIR=""
REPO_URL="${MINDFORGE_REPO:-https://github.com/adlerlei/MindForge.git}"
BRANCH="${MINDFORGE_BRANCH:-main}"

for arg in "$@"; do
  case "$arg" in
    --force|-f) FORCE=1 ;;
    --source=*) SOURCE_DIR="${arg#*=}" ;;
    --repo=*) REPO_URL="${arg#*=}" ;;
    --branch=*) BRANCH="${arg#*=}" ;;
    --help|-h)
      cat <<'EOF'
MindForge installer

Usage:
  bash scripts/install.sh [options]

Options:
  --force, -f          Overwrite existing install
  --source=PATH        Install from local path (default: this repo)
  --repo=URL           Git URL for remote install
  --branch=NAME        Git branch (default: main)
  -h, --help           Show help

Env:
  MINDFORGE_HOME       Override install root (default: ~/.agents/skills/MindForge)
  MINDFORGE_DISTILLED  Override distilled root (default: ~/.agents/skills/distilled)
EOF
      exit 0
      ;;
    *)
      echo "Unknown option: $arg (try --help)"
      exit 1
      ;;
  esac
done

GLOBAL_ROOT="${MINDFORGE_HOME:-$HOME/.agents/skills/MindForge}"
DISTILLED_ROOT="${MINDFORGE_DISTILLED:-$HOME/.agents/skills/distilled}"
AGENTS_SKILLS="$HOME/.agents/skills"

# Resolve source: local repo > --source > clone
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

if [[ -n "$SOURCE_DIR" ]]; then
  SRC="$(cd "$SOURCE_DIR" && pwd)"
elif [[ -f "$REPO_ROOT/SKILL.md" ]]; then
  SRC="$REPO_ROOT"
else
  SRC=""
fi

echo "⚒️  MindForge installer"
echo "   Target: $GLOBAL_ROOT"
echo ""

mkdir -p "$AGENTS_SKILLS" "$DISTILLED_ROOT"

engine_ok() {
  [[ -f "$GLOBAL_ROOT/SKILL.md" ]]
}

# Broken self-symlink or force → reinstall
if [[ -L "$GLOBAL_ROOT" ]] || [[ -e "$GLOBAL_ROOT" ]]; then
  if ! engine_ok || [[ "$FORCE" -eq 1 ]]; then
    echo "🗑  Removing previous install (force or broken)"
    rm -rf "$GLOBAL_ROOT"
  fi
fi

if engine_ok && [[ "$FORCE" -eq 0 ]]; then
  if [[ -L "$GLOBAL_ROOT" ]]; then
    echo "↻ Already linked at $GLOBAL_ROOT → $(readlink "$GLOBAL_ROOT")"
  else
    echo "↻ Already installed at $GLOBAL_ROOT"
  fi
  echo "   Use --force to reinstall, or: mindforge link"
else
  if [[ -n "$SRC" && -f "$SRC/SKILL.md" ]]; then
    # Default: COPY clean tree (avoids agent CLIs recursively indexing reference projects).
    # Dev symlink: MINDFORGE_LINK=1 bash scripts/install.sh --force
    if [[ "${MINDFORGE_LINK:-0}" == "1" ]]; then
      echo "🔗 Linking install → $SRC (dev mode; agent may index entire repo)"
      ln -sfn "$SRC" "$GLOBAL_ROOT"
    else
      echo "📦 Copying engine from $SRC"
      mkdir -p "$GLOBAL_ROOT"
      if command -v rsync >/dev/null 2>&1; then
        rsync -a --delete \
          --exclude '.git' \
          --exclude '.DS_Store' \
          --exclude 'MindForge-DEV.md' \
          --exclude 'node_modules' \
          --exclude '*參考*' \
          --exclude '*参考*' \
          --exclude 'reference-project*' \
          "$SRC/" "$GLOBAL_ROOT/"
      else
        # Fallback without rsync: only ship known engine files
        rm -rf "$GLOBAL_ROOT"
        mkdir -p "$GLOBAL_ROOT"
        for item in SKILL.md VERSION README.md README.zh-TW.md LICENSE package.json references scripts examples; do
          if [[ -e "$SRC/$item" ]]; then
            cp -R "$SRC/$item" "$GLOBAL_ROOT/"
          fi
        done
      fi
    fi
  else
    echo "🌐 Cloning $REPO_URL (branch: $BRANCH)"
    TMP="$(mktemp -d)"
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TMP/MindForge"
    mkdir -p "$GLOBAL_ROOT"
    rsync -a --exclude '.git' --exclude '.DS_Store' --exclude '*參考*' --exclude '*参考*' \
      --exclude 'reference-project*' --exclude 'MindForge-DEV.md' \
      "$TMP/MindForge/" "$GLOBAL_ROOT/"
    rm -rf "$TMP"
  fi
fi

if ! engine_ok; then
  echo "❌ Install failed: $GLOBAL_ROOT/SKILL.md not readable"
  exit 1
fi

# Ensure distilled exists
mkdir -p "$DISTILLED_ROOT"

# Symlink distilled next to engine for discovery
if [[ ! -e "$AGENTS_SKILLS/distilled" ]]; then
  ln -sfn "$DISTILLED_ROOT" "$AGENTS_SKILLS/distilled" 2>/dev/null || true
fi

# Link into agent tools
LINK_SCRIPT="$GLOBAL_ROOT/scripts/link-agents.sh"
if [[ -f "$LINK_SCRIPT" ]]; then
  bash "$LINK_SCRIPT"
else
  echo "⚠ link-agents.sh missing at $LINK_SCRIPT — skip agent links"
fi

# Optional: put mindforge on PATH via ~/.local/bin
LOCAL_BIN="$HOME/.local/bin"
CLI_SRC="$GLOBAL_ROOT/scripts/mindforge"
if [[ -f "$CLI_SRC" ]]; then
  mkdir -p "$LOCAL_BIN"
  ln -sfn "$CLI_SRC" "$LOCAL_BIN/mindforge"
  if ! echo ":$PATH:" | grep -q ":$LOCAL_BIN:"; then
    echo ""
    echo "💡 Add to PATH if needed:"
    echo "   export PATH=\"\$HOME/.local/bin:\$PATH\""
  fi
  echo "✓ CLI: mindforge  → $LOCAL_BIN/mindforge"
fi

echo ""
echo "✅ MindForge installed"
echo "   Engine:    $GLOBAL_ROOT"
echo "   Distilled: $DISTILLED_ROOT"
echo ""
echo "Next:"
echo "  · In your Agent app, say: Forge <name>  /  Distill <name>"
echo "  · Manage: mindforge list | mindforge doctor | mindforge help"
echo "  · After installing a new Agent app: mindforge link"
echo "  · Docs: README.md (EN) · README.zh-TW.md (繁中)"
echo "  · Dev symlink: MINDFORGE_LINK=1 bash scripts/install.sh --force"
