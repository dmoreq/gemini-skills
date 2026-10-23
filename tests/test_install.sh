#!/usr/bin/env bash
set -euo pipefail

repository=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
root=$(mktemp -d "${TMPDIR:?Set TMPDIR to a scratch directory}/gemini-skills-test.XXXXXX")
trap 'rm -rf -- "$root"' EXIT
mkdir -p "$root/home" "$root/project"

HOME="$root/home" bash "$repository/install.sh" >"$root/first.log"
[[ $(find "$root/home/.agents/skills" -name SKILL.md -type f | wc -l | tr -d ' ') == 10 ]]
HOME="$root/home" bash "$repository/install.sh" >"$root/repeat.log"
[[ $(grep -c '^Already installed ' "$root/repeat.log") == 10 ]]

printf 'user edit\n' >>"$root/home/.agents/skills/code-guard/SKILL.md"
if HOME="$root/home" bash "$repository/install.sh" >"$root/conflict.log" 2>&1; then
  printf 'Expected conflict to fail\n' >&2
  exit 1
fi
grep -q 'Conflict:' "$root/conflict.log"
grep -q 'user edit' "$root/home/.agents/skills/code-guard/SKILL.md"

(cd "$root/project" && bash "$repository/install.sh" --scope workspace >"$root/workspace.log")
[[ $(find "$root/project/.agents/skills" -name SKILL.md -type f | wc -l | tr -d ' ') == 10 ]]
if bash "$repository/install.sh" --scope invalid >"$root/invalid.log" 2>&1; then
  printf 'Expected invalid scope to fail\n' >&2
  exit 1
fi
printf 'PASS: user install, idempotence, conflict protection, workspace install, invalid scope\n'
