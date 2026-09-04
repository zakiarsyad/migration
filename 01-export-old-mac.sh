#!/bin/zsh

set -e

EXPORT_DIR="$HOME/Desktop/mac-essential"
mkdir -p "$EXPORT_DIR"

echo "Exporting essential Mac setup to: $EXPORT_DIR"

# Homebrew package and application lists.
if command -v brew >/dev/null 2>&1; then
  brew bundle dump --file="$EXPORT_DIR/Brewfile" --force
else
  echo "Homebrew is not installed; skipping Brewfile."
fi

system_profiler SPApplicationsDataType > "$EXPORT_DIR/applications.txt"

# Terminal, Git, and common CLI configuration.
for file in .zshrc .zprofile .gitconfig; do
  if [ -f "$HOME/$file" ]; then
    cp "$HOME/$file" "$EXPORT_DIR/$file"
  fi
done

if [ -d "$HOME/.config" ]; then
  ditto "$HOME/.config" "$EXPORT_DIR/.config"
fi

echo
read "copy_ssh?Copy ~/.ssh too? This may contain private keys [y/N]: "
if [[ "$copy_ssh" == [yY] ]]; then
  if [ -d "$HOME/.ssh" ]; then
    ditto "$HOME/.ssh" "$EXPORT_DIR/.ssh"
    chmod 700 "$EXPORT_DIR/.ssh"
    find "$EXPORT_DIR/.ssh" -type f ! -name '*.pub' -exec chmod 600 {} \;
    find "$EXPORT_DIR/.ssh" -type f -name '*.pub' -exec chmod 644 {} \;
  fi
else
  echo "Skipping ~/.ssh. Generate new keys on the new Mac if needed."
fi

echo
echo "Done. Review this folder before transferring it:"
echo "  $EXPORT_DIR"
echo "Do not upload it to GitHub if it contains private SSH keys."
