#!/usr/bin/env bash

set -e

PACKAGES_PAC=("base-devel" "git" "hyprland" "starship" "yazi" "nautilus" "ttf-jetbrains-mono-nerd" "fish" "qt6-declarative" "Matugen" "ly" "rofi" "nwg-look")
PACKAGES_AUR=("quickshell-git" "linux-wallpaperengine-git" "skwd-daemon-bin" "skwd-wall")

FILE="$HOME/.config/install.flag"
FOLDERS=("hypr" "Kitty" "fastfetch" "rofi")

if [ -f "$FILE" ]; then 
    echo "Ya se realizó correctamente la instalación. Saltando..."
    exit 0
else
    mkdir -p "$HOME/.config"
    
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm "${PACKAGES_PAC[@]}"

    # Instalación de YAY
    git clone https://aur.archlinux.org/yay.git "$HOME/yay"
    cd "$HOME/yay"
    makepkg -si --noconfirm
    cd "$HOME"
    rm -rf "$HOME/yay"

    if command -v yay &> /dev/null; then
        echo "yay instalado correctamente."
        yay -S --noconfirm "${PACKAGES_AUR[@]}"

        git clone https://github.com/Harol-d/Dotfiles "$HOME/Dotfiles"

        for folder in "${FOLDERS[@]}"; do
            if [ -d "$HOME/Dotfiles/$folder" ]; then
                cp -rv "$HOME/Dotfiles/$folder" "$HOME/.config/"
            fi
        done
        rm -rf "$HOME/Dotfiles"

        sudo systemctl enable --now skwd-daemon.service
        sudo systemctl disable getty@tty2.service
        sudo systemctl enable --now ly@tty2.service

        chsh -s "$(which fish)"
        mkdir -p "$HOME/.config/fish"

        cat << 'EOF' >> "$HOME/.config/fish/config.fish"
if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    bash $HOME/.config/hypr/Scripts/init.sh
end
EOF

        touch "$FILE"

        echo "Instalación completada. Por favor reinicia tu sistema."
        exit 0
    else
        echo "Hubo un problema en la instalación del asistente YAY/AUR."
        exit 1
    fi
fi