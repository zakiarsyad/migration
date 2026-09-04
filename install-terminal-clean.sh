#!/bin/zsh

set -e

echo "Installing a clean Terminal setup. No files are copied from the old Mac."

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

BREW_PREFIX="$(brew --prefix)"
echo "eval \"$($BREW_PREFIX/bin/brew shellenv zsh)\"" >> "$HOME/.zprofile"
eval "$($BREW_PREFIX/bin/brew shellenv zsh)"

brew update
brew install \
  asdf \
  cloudflared \
  colima \
  coreutils \
  curl \
  docker \
  docker-compose \
  ffmpeg \
  gh \
  git \
  jupyterlab \
  lazydocker \
  make \
  mercurial \
  poppler \
  ripgrep \
  sqlc \
  yt-dlp

brew install stripe/stripe-cli/stripe

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$HOME/.zshrc.before-terminal-install"
fi

cat > "$HOME/.zshrc" <<'EOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
  git
  docker
  docker-compose
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"

# asdf version manager
export PATH="$(brew --prefix asdf)/bin:$PATH"
export PATH="$HOME/.asdf/shims:$PATH"
EOF

asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git 2>/dev/null || true
asdf plugin add golang https://github.com/asdf-community/asdf-golang.git 2>/dev/null || true

asdf install nodejs 22.22.2
asdf set -u nodejs 22.22.2
asdf install golang 1.24.0
asdf set -u golang 1.24.0

echo
echo "Terminal installation complete."
echo "Open a new Terminal window, then verify with:"
echo "  node --version"
echo "  go version"
echo "  git --version"
echo "  brew list"
