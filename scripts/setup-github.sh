#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-ISSPB/project-progress-tracking}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
GH_BIN="${GH_BIN:-gh}"

cd "$ROOT"

if ! /usr/bin/git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not a git repository: $ROOT"
  exit 1
fi

if ! command -v "$GH_BIN" >/dev/null 2>&1; then
  echo "GitHub CLI (gh) is required. Install from https://cli.github.com/ or set GH_BIN."
  exit 1
fi

if ! "$GH_BIN" auth status >/dev/null 2>&1; then
  echo "Run: gh auth login"
  exit 1
fi

if ! "$GH_BIN" repo view "$REPO" >/dev/null 2>&1; then
  echo "Creating repository $REPO ..."
  CREATE_ARGS=(--public --source=. --push --description "Integrated System project timeline and GovTech KM compliance dashboard")
  if /usr/bin/git remote get-url origin >/dev/null 2>&1; then
    "$GH_BIN" repo create "$REPO" "${CREATE_ARGS[@]}" || {
      echo "Repository may exist; continuing with existing origin remote."
    }
  else
    "$GH_BIN" repo create "$REPO" "${CREATE_ARGS[@]}" --remote=origin
  fi
else
  if ! /usr/bin/git remote get-url origin >/dev/null 2>&1; then
    /usr/bin/git remote add origin "git@github.com:${REPO}.git"
  fi
  /usr/bin/git push -u origin main
fi

echo "Enabling GitHub Pages (workflow source) ..."
"$GH_BIN" api -X PUT "repos/${REPO}/pages" -f build_type=workflow 2>/dev/null || true

echo ""
echo "Done. After the Pages workflow runs, open:"
echo "  https://${REPO%%/*}.github.io/${REPO##*/}/"
