#!/usr/bin/env bash
# Publish wiki/*.md to the GitHub Wiki remote.
# Prerequisite: the wiki must have at least one page (create via the GitHub UI
# once if `git ls-remote ...wiki.git` fails with "not found").
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WIKI_SRC="$ROOT/wiki"
REMOTE="${WIKI_REMOTE:-https://github.com/bluehive/re-sketching-rhombus.wiki.git}"
WORKDIR="${WIKI_WORKDIR:-$(mktemp -d)}"
cleanup() {
  if [[ "${WIKI_WORKDIR:-}" == "" ]]; then
    rm -rf "$WORKDIR"
  fi
}
trap cleanup EXIT

if ! git ls-remote "$REMOTE" &>/dev/null; then
  cat <<EOF >&2
Wiki remote not available yet: $REMOTE

GitHub creates the wiki git repo only after the first page exists.
1. Open https://github.com/bluehive/re-sketching-rhombus/wiki
2. Click "Create the first page", save any stub (e.g. title Home)
3. Re-run: bash scripts/publish-wiki.sh
EOF
  exit 1
fi

git clone --depth 1 "$REMOTE" "$WORKDIR"
# Replace pages with our sources (keep .git)
find "$WORKDIR" -maxdepth 1 -type f -name '*.md' -delete
cp -a "$WIKI_SRC"/. "$WORKDIR"/
cd "$WORKDIR"
git add -A
if git diff --cached --quiet; then
  echo "Wiki already up to date."
  exit 0
fi
git -c user.email="${GIT_AUTHOR_EMAIL:-wiki-bot@users.noreply.github.com}" \
    -c user.name="${GIT_AUTHOR_NAME:-re-sketching-wiki}" \
    commit -m "docs: sync drawing API wiki from repository wiki/"
git push origin HEAD
echo "Published wiki from $WIKI_SRC"
