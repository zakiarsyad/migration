# Minimal Mac migration

This setup copies only the essentials:

- Terminal configuration: `.zshrc`, `.zprofile`, `.gitconfig`, and `.config`
- SSH configuration and keys, only if you choose to include them
- Homebrew formulae and casks
- A list of applications in `/Applications`
- Your selected personal folders

It does **not** use Migration Assistant and does not copy macOS system files or the entire `~/Library`.

## Step 1: old Mac

Copy this repository to the old Mac, then open Terminal in this folder and run:

```bash
chmod +x 01-export-old-mac.sh 02-restore-new-mac.sh
./01-export-old-mac.sh
```

The script creates:

```text
~/Desktop/mac-essential
```

Review that folder. It contains your Terminal configuration and package lists. If you do not use SSH, delete the `.ssh` folder before transferring it.

Transfer the entire `mac-essential` folder to the new Mac, placing it at:

```text
~/Desktop/mac-essential
```

You can use AirDrop, an external drive, iCloud Drive, or `rsync` over SSH. Do not commit this folder to GitHub because it may contain private SSH keys.

## Step 2: new Mac

On the new Mac, first install Apple Command Line Tools:

```bash
xcode-select --install
```

Then open Terminal in this repository and run:

```bash
chmod +x 02-restore-new-mac.sh
./02-restore-new-mac.sh
```

The restore script installs Homebrew, restores the packages in `Brewfile`, and copies the selected Terminal configuration files.

Restart Terminal afterward:

```bash
exec zsh
```

## Applications

Applications installed through Homebrew Cask are restored by `brew bundle`. Open `applications.txt` to see the other applications from the old Mac and reinstall only the ones you use.

You must manually sign in again to Apple, iCloud, password managers, VPNs, browsers, and licensed applications.

## Optional personal files

To copy a folder directly from the old Mac to the new Mac over SSH, run this on the new Mac:

```bash
rsync -aE --info=progress2 OLD_USERNAME@OLD_IP_ADDRESS:/Users/OLD_USERNAME/Documents/ "$HOME/Documents/"
```

Replace the placeholders. Repeat for `Desktop`, `Downloads`, `Pictures`, or your project folders.

Never use `--delete` unless you intentionally want the destination to remove files.
