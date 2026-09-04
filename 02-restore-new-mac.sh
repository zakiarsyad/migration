#!/bin/zsh

set -e

SOURCE_DIR="$HOME/Desktop/mac-essential"

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Missing: $SOURCE_DIR"
  echo "Transfer the mac-essential folder from the old Mac first."
  exit 1
fi

echo "Restoring essential setup from: $SOURCE_DIR"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not installed. Installing it now..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ -f "$SOURCE_DIR/Brewfile" ]; then
  brew bundle --file="$SOURCE_DIR/Brewfile"
else
  echo "No Brewfile found; skipping Homebrew packages."
fi

for file in .zshrc .zprofile .gitconfig; do
  if [ -f "$SOURCE_DIR/$file" ]; then
    cp "$SOURCE_DIR/$file" "$HOME/$file"
  fi
done

if [ -d "$SOURCE_DIR/.config" ]; then
  mkdir -p "$HOME/.config"
  ditto "$SOURCE_DIR/.config" "$HOME/.config"
fi

if [ -d "$SOURCE_DIR/.ssh" ]; then
  mkdir -p "$HOME/.ssh"
  ditto "$SOURCE_DIR/.ssh" "$HOME/.ssh"
  chmod 700 "$HOME/.ssh"
  find "$HOME/.ssh" -type f ! -name '*.pub' -exec chmod 600 {} \;
  find "$HOME/.ssh" -type f -name '*.pub' -exec chmod 644 {} \;
fi

echo
echo "Restore complete. Restart Terminal with:"
echo "  exec zsh"
echo
echo "Review applications.txt and reinstall non-Homebrew apps manually."
