#!/usr/bin/env bash
#
# check_colab_links.sh — validate every "Open in Colab" badge in this repo.
#
# For each README.md it finds Colab URLs of the form
#   https://colab.research.google.com/github/<owner>/<repo>/blob/<ref>/<path>
# and checks that:
#   1. <path> actually exists in the repository, and
#   2. <owner>/<repo> matches the `origin` remote.
#
# Template URLs containing placeholders like <folder>/<notebook>.ipynb are skipped.
#
# Usage:
#   scripts/check_colab_links.sh
#
# Exit code: 0 = all links valid, 1 = at least one broken.
# Handy as a git pre-push hook (see bottom of this file).

set -euo pipefail

# --- Resolve the repo root, regardless of where this is called from ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)"; then
    :
else
    ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
fi
cd "$ROOT"

# --- Expected owner/repo slug from the origin remote ---
REMOTE_URL="$(git remote get-url origin 2>/dev/null || true)"
SLUG="$(printf '%s' "$REMOTE_URL" \
    | sed -E 's#^git@github\.com:##; s#^https://github\.com/##; s#\.git$##')"

URL_RE='https://colab\.research\.google\.com/github/[^ )"<>]+/blob/[^ )"<>]+/[^ )"<>]+'

checked=0
broken=0
warned=0

report_ok()   { printf '  \033[32mOK\033[0m     %s\n' "$1"; }
report_bad()  { printf '  \033[31mBROKEN\033[0m %s  (%s)\n' "$1" "$2"; }
report_warn() { printf '  \033[33mWARN\033[0m   %s  (%s)\n' "$1" "$2"; }

while IFS= read -r file; do
    # Skip placeholder/template URLs
    while IFS= read -r url; do
        case "$url" in
            *'<'*|*'>'*) continue ;;
        esac

        checked=$((checked + 1))

        # Strip everything up to and including "/blob/<ref>/"
        rest="${url#*/blob/}"     # <ref>/<path>
        path="${rest#*/}"         # <path>
        path="${path//%20/ }"     # decode spaces (%20) in notebook filenames

        if [[ -f "$path" ]]; then
            report_ok "$path"
        else
            report_bad "$path" "$file"
            broken=$((broken + 1))
        fi

        if [[ -n "$SLUG" && "$url" != *"/github/$SLUG/"* ]]; then
            report_warn "owner/repo mismatch, expected '$SLUG'" "$url"
            warned=$((warned + 1))
        fi
    done < <(grep -oE "$URL_RE" "$file" 2>/dev/null || true)
done < <(find . -name 'README.md' \
            -not -path './.git/*' \
            -not -path './.venv/*' \
            -not -path './data/*' \
            -not -path './**/data/*' | sort)

printf '\nChecked %d Colab link(s): %d broken, %d warning(s).\n' "$checked" "$broken" "$warned"

if [[ "$broken" -gt 0 ]]; then
    printf '\033[31mFAIL\033[0m — fix the broken Colab badge(s) above.\n'
    exit 1
fi
printf '\033[32mPASS\033[0m — all Colab badges point to existing notebooks.\n'

# ---------------------------------------------------------------------------
# Optional: run automatically before every push.
#
#   ln -sf ../../scripts/check_colab_links.sh .git/hooks/pre-push
#
# (git hooks live in .git/ and are not committed, hence the manual link.)
# ---------------------------------------------------------------------------
