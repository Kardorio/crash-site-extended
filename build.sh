#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

MOD_NAME="crash-site-extended"
DIST="$ROOT/dist"

CONTENTS=(
  info.json
  data-final-fixes.lua
  changelog.txt
  thumbnail.png
  README.md
  docs
  locale
)

mod_version() {
  python3 -c "import json; print(json.load(open('info.json'))['version'])"
}

game_version() {
  python3 -c "import json; print(json.load(open('info.json'))['factorio_version'])"
}

package() {
  local modver
  local gamever
  local stage
  modver="$(mod_version)"
  gamever="$(game_version)"
  stage="$DIST/${MOD_NAME}_${modver}"

  rm -rf "$DIST"
  mkdir -p "$stage"
  for item in "${CONTENTS[@]}"; do
    cp -r "$item" "$stage/"
  done

  (cd "$DIST" && zip -qr "${MOD_NAME}_${modver}.zip" "${MOD_NAME}_${modver}")
  rm -rf "$stage"
  echo "  → dist/${MOD_NAME}_${modver}.zip   (Factorio ${gamever})"
  echo "Packaging OK (version=${modver})."
}

link_dev() {
  local mods="$HOME/.factorio/mods"
  [ -d "$mods" ] || { echo "Dossier mods introuvable : $mods" >&2; exit 1; }

  rm -f "$mods/${MOD_NAME}_"*.zip
  ln -sfn "$ROOT" "$mods/$MOD_NAME"
  echo "Lien dev : $mods/$MOD_NAME -> $ROOT"
  echo "Après une modification du data-stage, redémarrer Factorio."
}

unlink_dev() {
  local link="$HOME/.factorio/mods/$MOD_NAME"
  if [ -L "$link" ]; then
    rm -f "$link"
    echo "Lien dev retiré : $link"
  else
    echo "Aucun lien dev à retirer."
  fi
}

install_local() {
  local mods="$HOME/.factorio/mods"
  local modver
  package
  modver="$(mod_version)"
  [ -d "$mods" ] || { echo "Dossier mods introuvable : $mods" >&2; exit 1; }
  cp "$DIST/${MOD_NAME}_${modver}.zip" "$mods/"
  echo "Installé dans $mods/${MOD_NAME}_${modver}.zip"
}

case "${1:-package}" in
  package) package ;;
  link|devlink) link_dev ;;
  unlink) unlink_dev ;;
  install) install_local ;;
  clean) rm -rf "$DIST"; echo "dist/ supprimé." ;;
  *) echo "Usage : $0 {package|link|devlink|unlink|install|clean}" >&2; exit 2 ;;
esac
