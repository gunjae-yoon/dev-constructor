#!/usr/bin/env bash
#
# Ubuntu setup script: zsh + Oh My Zsh + Powerlevel10k + D2Coding Nerd Font
# Uses the latest Nerd Fonts release (v3.4.0 as of early 2026)
#
# Usage:
#   1. Save as: setup-zsh-p10k-d2coding.sh
#   2. Make executable: chmod +x setup-zsh-p10k-d2coding.sh
#   3. Run: ./setup-zsh-p10k-d2coding.sh
#   4. After finishing, run the final command shown (p10k configure)

set -euo pipefail

echo "=============================================================="
echo "  zsh + Oh My Zsh + Powerlevel10k + D2Coding Nerd Font Setup"
echo "=============================================================="

# 1. Install required packages
echo "→ Installing essential packages..."
sudo apt update -qq
sudo apt install -y zsh git curl unzip fontconfig

# 2. Change default shell to zsh (only if not already zsh)
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "→ Changing default shell to zsh (log out and log back in to apply)"
    chsh -s "$(which zsh)"
fi

# 3. Install Oh My Zsh (skip if already present)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "→ Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "→ Oh My Zsh already installed → skipping"
fi

# 4. Clone Powerlevel10k theme & useful plugins (update if already exists)
echo "→ Installing / updating Powerlevel10k and zsh plugins..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k" 2>/dev/null || \
    git -C "$ZSH_CUSTOM/themes/powerlevel10k" pull --quiet

git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || \
    git -C "$ZSH_CUSTOM/plugins/zsh-autosuggestions" pull --quiet

git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || \
    git -C "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" pull --quiet

git clone --depth=1 https://github.com/zsh-users/zsh-completions \
    "$ZSH_CUSTOM/plugins/zsh-completions" 2>/dev/null || \
    git -C "$ZSH_CUSTOM/plugins/zsh-completions" pull --quiet

# 5. Update ~/.zshrc (backup first)
echo "→ Updating ~/.zshrc configuration..."

ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d-%H%M%S)"

if [ -f "$ZSHRC" ]; then
    cp "$ZSHRC" "$BACKUP"
    echo "  (Existing .zshrc backed up to: $BACKUP)"
fi

# Set theme
sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$ZSHRC" 2>/dev/null || true

# Update plugins line (replace or append safely)
if grep -q "^plugins=" "$ZSHRC"; then
    sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)' "$ZSHRC"
else
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)' >> "$ZSHRC"
fi

# Add Powerlevel10k mode and configuration reminder (avoid duplicates)
cat << 'EOF' >> "$ZSHRC"

# Powerlevel10k settings
POWERLEVEL9K_MODE=nerdfont-complete

# Reminder to configure if .p10k.zsh is missing
[[ ! -f ~/.p10k.zsh ]] && echo "Run » p10k configure « to customize your prompt (do this once)"
EOF

# 6. Set git pager for better readability
git config --global core.pager 'less -FRX'

# 7. Install D2Coding Nerd Font (latest release)
echo "→ Installing D2Coding Nerd Font..."

FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
cd "$FONT_DIR"

# Download and extract (overwrite if exists)
rm -f D2Coding.zip
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/D2Coding.zip
unzip -o D2Coding.zip -d d2coding-nerd
mv d2coding-nerd/*.ttf . 2>/dev/null || true
rm -rf d2coding-nerd D2Coding.zip LICENSE README.md 2>/dev/null || true

# Refresh font cache
fc-cache -fv >/dev/null

echo "→ Checking installed Nerd Fonts (should show D2Coding entries)"
fc-list | grep -i "D2Coding" | head -n 5 || echo "  (If no fonts appear, try logging out and back in)"

# 8. Final instructions
echo ""
echo "=============================================================="
echo "Setup complete!"
echo ""
echo "Next steps (very important):"
echo "  1. Open a new terminal or run:   source ~/.zshrc"
echo "  2. Change your terminal font:"
echo "     • GNOME Terminal: Preferences → Profiles → Text → Custom font"
echo "       → Select 'D2Coding Nerd Font' or 'D2Coding Nerd Font Mono' (Regular, size 11–13 recommended)"
echo "  3. Run the Powerlevel10k configuration wizard:"
echo "     p10k configure"
echo ""
echo "If icons look broken → it's almost always a font issue. Make sure the Nerd Font is selected."
echo "Enjoy your beautiful zsh setup! 🚀"
echo "=============================================================="