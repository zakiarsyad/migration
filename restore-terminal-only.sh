#!/bin/zsh

set -e

SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)/mac-terminal-config"
BACKUP_DIR="$HOME/Desktop/mac-terminal-config-backup-$(date +%Y%m%d-%H%M%S)"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Missing: $SOURCE_DIR"
  echo "Copy mac-terminal-config from the old Mac into this migration folder first."
  exit 1
fi

mkdir -p "$BACKUP_DIR"

for file in \
  .zshenv .zshrc .zprofile .zlogin .zlogout \
  .bashrc .bash_profile .bash_login .bash_logout \
  .gitconfig .vimrc .tmux.conf .inputrc; do
  if [ -f "$SOURCE_DIR/$file" ]; then
    [ -e "$HOME/$file" ] && cp "$HOME/$file" "$BACKUP_DIR/$file"
    cp "$SOURCE_DIR/$file" "$HOME/$file"
    echo "Restored $file"
  fi
done

if [ -d "$SOURCE_DIR/.config" ]; then
  [ -d "$HOME/.config" ] && ditto "$HOME/.config" "$BACKUP_DIR/.config"
  mkdir -p "$HOME/.config"
  ditto "$SOURCE_DIR/.config" "$HOME/.config"
  echo "Restored .config"
fi

if [ -d "$SOURCE_DIR/.ssh" ]; then
  [ -d "$HOME/.ssh" ] && ditto "$HOME/.ssh" "$BACKUP_DIR/.ssh"
  mkdir -p "$HOME/.ssh"
  ditto "$SOURCE_DIR/.ssh" "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  find "$HOME/.ssh" -type f ! -name '*.pub' -exec chmod 600 {} \;
  find "$HOME/.ssh" -type f -name '*.pub' -exec chmod 644 {} \;
  echo "Restored .ssh"
fi

echo
echo "Done. Existing files were backed up to: $BACKUP_DIR"
echo "Reload Terminal with: exec zsh"
