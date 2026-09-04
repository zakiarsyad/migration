#!/bin/zsh

set -e

EXPORT_DIR="$(cd "$(dirname "$0")" && pwd)/mac-terminal-config"
mkdir -p "$EXPORT_DIR"

echo "Exporting Terminal configuration to: $EXPORT_DIR"

for file in \
  .zshenv .zshrc .zprofile .zlogin .zlogout \
  .bashrc .bash_profile .bash_login .bash_logout \
  .gitconfig .vimrc .tmux.conf .inputrc; do
  if [ -f "$HOME/$file" ]; then
    cp "$HOME/$file" "$EXPORT_DIR/$file"
    echo "Copied $file"
  fi
done

if [ -d "$HOME/.config" ]; then
  mkdir -p "$EXPORT_DIR/.config"
  rsync -aE \
    --exclude='sockets' \
    --exclude='*.sock' \
    "$HOME/.config/" "$EXPORT_DIR/.config/"
  echo "Copied .config"
fi

# Needed for GitHub SSH access and remote servers. These files are gitignored.
if [ -d "$HOME/.ssh" ]; then
  mkdir -p "$EXPORT_DIR/.ssh"
  rsync -aE \
    --exclude='agent' \
    --exclude='*.sock' \
    "$HOME/.ssh/" "$EXPORT_DIR/.ssh/"
  chmod 700 "$EXPORT_DIR/.ssh"
  find "$EXPORT_DIR/.ssh" -type f ! -name '*.pub' -exec chmod 600 {} \;
  find "$EXPORT_DIR/.ssh" -type f -name '*.pub' -exec chmod 644 {} \;
  echo "Copied .ssh"
fi

echo
echo "Finished. Your local export is here:"
echo "  $EXPORT_DIR"
echo
echo "Copy this mac-terminal-config folder to the new Mac."
echo "Do not upload it to GitHub because it may contain private SSH keys."
