#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: %s [--scope user|workspace]\n' "${0##*/}"
  printf 'Install all skills for Gemini CLI without overwriting existing skills.\n'
}

scope=user
if [[ ${1:-} == --help || ${1:-} == -h ]]; then
  usage
  exit 0
fi
if [[ $# -gt 0 ]]; then
  if [[ $# -ne 2 || $1 != --scope || ( $2 != user && $2 != workspace ) ]]; then
    usage >&2
    exit 2
  fi
  scope=$2
fi

source_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
if [[ $scope == user ]]; then
  destination="$HOME/.agents/skills"
else
  destination="$PWD/.agents/skills"
fi

skills=("$source_root"/*/SKILL.md)
if [[ ! -f ${skills[0]} ]]; then
  printf 'No skills found in %s\n' "$source_root" >&2
  exit 1
fi

# Reject conflicts before writing any skill.
for skill in "${skills[@]}"; do
  name=${skill%/SKILL.md}
  name=${name##*/}
  existing="$destination/$name"
  if [[ -L $existing ]]; then
    printf 'Conflict: %s is a symlink; refusing to overwrite.\n' "$existing" >&2
    exit 1
  fi
  if [[ -e $existing ]] && ! diff -qr "${skill%/SKILL.md}" "$existing" >/dev/null; then
    printf 'Conflict: %s differs; refusing to overwrite.\n' "$existing" >&2
    exit 1
  fi
done

mkdir -p -- "$destination"
staging=$(mktemp -d "$destination/.skill-install.XXXXXX")
trap 'rm -rf -- "$staging"' EXIT
for skill in "${skills[@]}"; do
  directory=${skill%/SKILL.md}
  name=${directory##*/}
  if [[ ! -e $destination/$name ]]; then
    cp -R -- "$directory" "$staging/$name"
  fi
done
for skill in "${skills[@]}"; do
  name=${skill%/SKILL.md}
  name=${name##*/}
  if [[ -d $staging/$name ]]; then
    mv -- "$staging/$name" "$destination/$name"
    printf 'Installed %s\n' "$name"
  else
    printf 'Already installed %s\n' "$name"
  fi
done
printf 'Target: %s\nRun /skills reload, then /skills list in Gemini CLI.\n' "$destination"
