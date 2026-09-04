# Clean Terminal installation

Use this when setting up the new Mac. It installs a fresh Terminal environment and does not copy any files from the old Mac.

From this repository, run:

```bash
chmod +x install-terminal-clean.sh
./install-terminal-clean.sh
```

The installer sets up:

- Homebrew
- Oh My Zsh with the `robbyrussell` theme
- Git and Docker Oh My Zsh plugins
- zsh autosuggestions and syntax highlighting
- common CLI tools used on the old Mac
- `asdf`
- Node.js `22.22.2`
- Go `1.24.0`

It creates a new `.zshrc`. If the new Mac already has one, it saves it as `.zshrc.before-terminal-install`.

The script does not install GUI applications, copy SSH keys, copy Git settings, copy personal files, or copy the old Mac’s configuration.
