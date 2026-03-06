#!/usr/bin/env bash
set -euo pipefail

# csession installer
# Usage: curl -fsSL https://raw.githubusercontent.com/ksirrah13/agent-tools/main/csession/install.sh | bash

REPO="ksirrah13/agent-tools"
REPO_PATH="csession"
INSTALL_DIR="${CSESSION_INSTALL_DIR:-$HOME/.local/bin}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

info() { echo -e "${BLUE}>>>${NC} $*"; }
success() { echo -e "${GREEN}>>>${NC} $*"; }
warn() { echo -e "${YELLOW}>>>${NC} $*"; }
error() { echo -e "${RED}>>>${NC} $*" >&2; }

echo -e "${BOLD}csession installer${NC}"
echo ""

# --- Prerequisites ---
info "Checking prerequisites..."
missing=false
for cmd in tmux git curl; do
  if command -v "$cmd" &>/dev/null; then
    echo -e "  ${GREEN}OK${NC}  $cmd"
  else
    echo -e "  ${RED}MISSING${NC}  $cmd"
    missing=true
  fi
done

if command -v claude &>/dev/null; then
  echo -e "  ${GREEN}OK${NC}  claude"
else
  echo -e "  ${YELLOW}WARN${NC}  claude (install from https://docs.anthropic.com/en/docs/claude-code)"
fi

if [[ "$missing" == true ]]; then
  error "Install missing prerequisites first"
  exit 1
fi
echo ""

# --- Download ---
mkdir -p "$INSTALL_DIR"

BASE_URL="https://raw.githubusercontent.com/$REPO/main/$REPO_PATH"

download_file() {
  local file="$1"
  local dest="$2"
  info "Downloading $file..."
  curl -fsSL "$BASE_URL/$file" -o "$dest" || {
    error "Failed to download $file from $BASE_URL/$file"
    exit 1
  }
}

download_file "csession" "$INSTALL_DIR/csession"
chmod +x "$INSTALL_DIR/csession"
success "Installed csession"

download_file "_csession" "$INSTALL_DIR/_csession"
success "Installed zsh completion"
echo ""

# --- PATH ---
if echo ":$PATH:" | grep -q ":$INSTALL_DIR:"; then
  echo -e "  ${GREEN}OK${NC}  $INSTALL_DIR is in PATH"
else
  warn "$INSTALL_DIR is not in your PATH"
  SHELL_RC=""
  case "$(basename "$SHELL")" in
    zsh)  SHELL_RC="$HOME/.zshrc" ;;
    bash) SHELL_RC="$HOME/.bashrc" ;;
  esac

  if [[ -n "$SHELL_RC" ]]; then
    if ! grep -q "$INSTALL_DIR" "$SHELL_RC" 2>/dev/null; then
      echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_RC"
      success "Added $INSTALL_DIR to PATH in $SHELL_RC"
    fi
  else
    echo "  Add to your shell rc: export PATH=\"$INSTALL_DIR:\$PATH\""
  fi
fi

# --- Zsh completion ---
if [[ "$(basename "$SHELL")" == "zsh" ]]; then
  RC_FILE="$HOME/.zshrc"

  # fpath
  if grep -q "fpath=.*local/bin" "$RC_FILE" 2>/dev/null || \
     grep -q "fpath=.*${INSTALL_DIR}" "$RC_FILE" 2>/dev/null; then
    echo -e "  ${GREEN}OK${NC}  fpath configured"
  else
    echo "" >> "$RC_FILE"
    echo "# csession completions" >> "$RC_FILE"
    echo "fpath=($INSTALL_DIR \$fpath)" >> "$RC_FILE"
    success "Added fpath to $RC_FILE"
  fi

  # compinit
  if grep -q "compinit" "$RC_FILE" 2>/dev/null; then
    echo -e "  ${GREEN}OK${NC}  compinit configured"
  else
    # Add compinit right after the fpath line we just added (or at end)
    echo 'autoload -Uz compinit && compinit' >> "$RC_FILE"
    success "Added compinit to $RC_FILE"
  fi
fi
echo ""

# --- Done ---
success "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Run 'csession setup' to configure (interactive)"
echo "  2. Run 'csession template init' to create default templates"
echo "  3. Run 'csession new my-task --repo <repo>' to start"
echo ""
echo "If csession is not found, open a new terminal or run:"
echo "  source ~/.zshrc"
