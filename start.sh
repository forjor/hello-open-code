#!/usr/bin/env bash
# One-shot: start the OpenCode devcontainer and drop into a shell.
# Run from the project root on macOS.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
NC='\033[0m'

ok()   { echo -e "${GRN}✓ $*${NC}"; }
warn() { echo -e "${YLW}⚠ $*${NC}"; }
die()  { echo -e "${RED}✗ $*${NC}" >&2; exit 1; }

echo "── Prerequisites ─────────────────────────────────────"

# Docker
command -v docker &>/dev/null || die "Docker not found. Install Docker Desktop: https://www.docker.com/products/docker-desktop/"
docker info &>/dev/null       || die "Docker daemon is not running. Start Docker Desktop first."
ok "Docker"

# devcontainer CLI
if ! command -v devcontainer &>/dev/null; then
  warn "devcontainer CLI not found — installing via npm..."
  command -v npm &>/dev/null || die "npm not found. Install Node.js (https://nodejs.org) then re-run."
  npm install -g @devcontainers/cli
fi
ok "devcontainer CLI ($(devcontainer --version))"

# opencode config/data dirs on the host (bind-mounted into the container)
for d in "$HOME/.config/opencode" "$HOME/.local/share/opencode"; do
  [[ -d "$d" ]] || { warn "$d not found — creating it."; mkdir -p "$d"; }
done
ok "~/.config/opencode and ~/.local/share/opencode exist"

echo ""
echo "── Starting devcontainer ─────────────────────────────"
devcontainer up --workspace-folder "$SCRIPT_DIR"

echo ""
echo "── Connecting ────────────────────────────────────────"
echo "Inside the container: export a provider key, then \`make hello\`."
exec devcontainer exec --workspace-folder "$SCRIPT_DIR" zsh
