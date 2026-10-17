#!/usr/bin/env bash
# Opens (or updates) the pull request that adds NAME:VERSION to typst/packages.
# Usage: scripts/publish.sh NAME VERSION BUNDLE_DIR
# Uses the `gh` login, or GH_TOKEN when set (as in the release workflow).
set -euo pipefail

name=$1
version=$2
bundle=$(realpath "$3")
root=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

owner=$(gh api user --jq .login)
token=${GH_TOKEN:-$(gh auth token)}
branch="$name-$version"

gh repo fork typst/packages --clone=false >/dev/null 2>&1 || true
until gh repo view "$owner/packages" >/dev/null 2>&1; do sleep 5; done
gh repo sync "$owner/packages" --source typst/packages --force

git clone --quiet --depth 1 --filter=blob:none --sparse \
  "https://x-access-token:$token@github.com/$owner/packages.git" "$work/packages"
cd "$work/packages"
git sparse-checkout set "packages/preview/$name"
git switch --quiet -c "$branch"

existing=$(ls "packages/preview/$name" 2>/dev/null | grep -vx "$version" | wc -l || true)
rm -rf "packages/preview/$name/$version"
mkdir -p "packages/preview/$name"
cp -r "$bundle" "packages/preview/$name/$version"
git add "packages/preview/$name/$version"
git -c user.name="$owner" -c user.email="$owner@users.noreply.github.com" \
  -c commit.gpgsign=false commit --quiet -m "$name:$version"
git push --quiet --force origin "$branch"

notes=$(awk -v v="$version" '$0 ~ "^## \\[" v "\\]" {f=1; next} /^## \[/ {f=0} f' "$root/CHANGELOG.md" \
  | grep -v '^\[.*\]: ')
{
  echo "I am submitting"
  if [ "$existing" -eq 0 ]; then echo "- [x] a new package"; else echo "- [x] an update for a package"; fi
  echo
  echo "Description: Diploma thesis template following the Gdańsk University of Technology (Politechnika Gdańska) guidelines."
  echo "$notes"
  if [ "$existing" -eq 0 ]; then
    cat <<'EOF'

I have read and followed the submission guidelines and, in particular, I
- [x] selected a name that isn't the most obvious or canonical name for what the package does
  - Explanation: "PG" is the common abbreviation of Politechnika Gdańska; the name is specific to that university.
- [x] added a `typst.toml` file with all required keys
- [x] added a `README.md` with documentation for my package
- [x] have chosen a license and added a `LICENSE` file or linked one in my `README.md`
- [x] tested my package locally on my system and it worked
- [x] `exclude`d PDFs or README images, if any, but not the LICENSE
- [x] ensured that my package is licensed such that users can use and distribute the contents of its template directory without restriction, after modifying them through normal use.
EOF
  fi
} > "$work/body.md"

open=$(gh pr list -R typst/packages --author "$owner" --head "$branch" --state open --json url --jq '.[0].url // ""')
if [ -n "$open" ]; then
  echo "Updated $open"
else
  gh pr create -R typst/packages --head "$owner:$branch" --title "$name:$version" --body-file "$work/body.md"
fi
