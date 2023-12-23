#!/usr/bin/bash

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check internet connectivity
if ping -c 1 1.1.1.1 &> /dev/null; then
    echo -e "${GREEN}Internet is reachable. Proceeding with the installation.${NC}"
else
    echo -e "${RED}Error: No internet connectivity. Exiting the script.${NC}"
    exit 1
fi

# Function to prompt user for confirmation
prompt_for_confirmation() {
    read -p "Do you want to proceed? (y/n): " choice
    case "$choice" in 
        y|Y ) ;;
        n|N ) echo -e "${YELLOW}Aborted by user. Exiting the script.${NC}"; exit 1;;
        * ) echo -e "${RED}Invalid choice. Exiting the script.${NC}"; exit 1;;
    esac
}
prompt_for_confirmation

# Necessary packages
echo -e "${GREEN}Installing necessary packages...${NC}"
sudo dnf install @"Common NetworkManager Submodules" @"Development Tools" @"Hardware Support" -y

# Fedora RPM Fusion
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Adding COPR packages, such as hyprland
echo -e "${GREEN}Adding COPR repositories...${NC}"
sudo dnf copr enable solopasha/hyprland -y
sudo dnf copr enable alebastr/sway-extras -y
sudo dnf copr enable trs-sod/swaylock-effects -y
sudo dnf copr enable atim/starship -y

# Updating repositories list
echo -e "${GREEN}Updating repositories...${NC}"
sudo dnf update -y

# Install Hyprland Necessary Packages
echo -e "${GREEN}Installing Hyprland packages...${NC}"
sudo dnf install hyprland waybar-git polkit-gnome swww kitty swaylock-effects swayidle mako xdg-user-dirs curl wget tar -y

# Create User Common directories
xdg-user-dirs-update 

# Install other necessary packages
echo -e "${GREEN}Installing other necessary packages...${NC}"
sudo dnf install pamixer gammastep starship brightnessctl lightdm bluez blueman cups rofi neofetch -y

# Install all thunar packages
sudo dnf install thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tumbler tumbler-extras file-roller -y

# Autologin using Lightdm
prompt_for_autologin() {
    read -p "Do you want to enable autologin? (y/n): " choice
    case "$choice" in 
        y|Y )
            echo -e "${GREEN}Configuring autologin with Lightdm...${NC}"
            sudo cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.bak
            sudo sed -i '/^\[Seat:\*]/a autologin-user='$(whoami) "/etc/lightdm/lightdm.conf"
            sudo sed -i '/^\[Seat:\*]/a autologin-user-timeout=0' "/etc/lightdm/lightdm.conf"
            sudo sed -i '/^\[Seat:\*]/a autologin-session=hyprland' "/etc/lightdm/lightdm.conf"
            ;;
        n|N ) echo -e "${YELLOW}Canceled by user. Not enabling autologin...${NC}" ;;
        * ) echo -e "${RED}Invalid choice. Not enabling autologin...${NC}" ;;
    esac
}
prompt_for_autologin
sudo systemctl enable lightdm
sudo systemctl set-default graphical.target

# Install Auto-cpufreq
prompt_for_auto_cpufreq() {
    read -p "Do you want to install Auto-cpufreq (For Laptops)? (y/n): " choice
    case "$choice" in 
        y|Y )
            echo -e "${GREEN}Installing Auto-cpufreq...${NC}"
            git clone https://github.com/AdnanHodzic/auto-cpufreq.git
            cd auto-cpufreq
            sudo ./auto-cpufreq-installer
            sudo auto-cpufreq --install
            cd ..
            rm -rf auto-cpufreq
            ;;
        n|N ) echo -e "${YELLOW}Canceled by user. Not installing Auto-cpufreq...${NC}" ;;
        * ) echo -e "${RED}Invalid choice. Not installing Auto-cpufreq...${NC}" ;;
    esac
}
prompt_for_auto_cpufreq

# Installing virtualization
prompt_for_virtualization() {
    read -p "Do you want to install virtualization? (y/n): " choice
    case "$choice" in 
        y|Y )
            echo -e "${GREEN}Enabling virtualization...${NC}"
            sudo dnf install @virtualization -y
            sudo cp /etc/libvirt/libvirtd.conf /etc/libvirt/libvirtd.conf.bak
            sudo sed -i '/^# unix_sock_group/s/.*/unix_sock_group = '"libvirt"'/' "/etc/libvirt/libvirtd.conf"
            sudo sed -i '/^# unix_sock_rw_perms/s/.*/unix_sock_rw_perms = '"0770"'/' "/etc/libvirt/libvirtd.conf"
            sudo usermod -a -G libvirt $(whoami)
            sudo systemctl enable libvirtd
            ;;
        n|N ) echo -e "${YELLOW}Canceled by user. Not installing virtualization...${NC}" ;;
        * ) echo -e "${RED}Invalid choice. Not installing virtualization...${NC}" ;;
    esac
}
prompt_for_virtualization

echo -e "${GREEN}Minimal Hyprland installed...${NC}"

prompt_for_confirmation() {
    read -p "Do you want to proceed with optional installations? (y/n): " choice
    case "$choice" in 
        y|Y ) ;;
        n|N ) echo -e "${YELLOW}Aborted by user. Exiting the script.${NC}"; exit 1;;
        * ) echo -e "${RED}Invalid choice. Exiting the script.${NC}"; exit 1;;
    esac
}
prompt_for_confirmation

# Install GUI packages
# Add repos
echo -e "${GREEN}Adding repositories...${NC}"
sudo dnf config-manager --add-repo https://repository.mullvad.net/rpm/stable/mullvad.repo -y
sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg -y
sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo -y
sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

# Install
echo -e "${GREEN}Installing GUI packages...${NC}"
sudo dnf install mullvad-vpn easyeffects calibre cool-retro-term baobab deluge-gtk gnome-disk-utility gnucash gparted kiwix-desktop firefox sublime-text mousepad kde-connect steam grub-customizer pavucontrol qalculate-gtk inkscape blender ristretto retroarch gimp gimp-resynthesizer gimp-lensfun rawtherapee hugin torbrowser-launcher vlc -y

# Flatpak apps
echo -e "${GREEN}Installing flatpak packages...${NC}"
sudo dnf install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install flathub com.github.iwalton3.jellyfin-media-player -y
flatpak install flathub com.mojang.Minecraft -y
flatpak install flathub com.heroicgameslauncher.hgl -y
flatpak install flathub md.obsidian.Obsidian -y
flatpak install flathub org.signal.Signal -y

# Install thorium
echo -e "${GREEN}Installing packages from GitHub...${NC}"
wget https://github.com/Alex313031/thorium/releases/download/M117.0.5938.157/thorium-browser_117.0.5938.157.x86_64.rpm
sudo dnf install ./thorium-browser_117.0.5938.157.x86_64.rpm  -y
rm thorium-browser_117.0.5938.157.x86_64.rpm 

# Install WebCord
wget https://github.com/SpacingBat3/WebCord/releases/download/v4.5.2/webcord-4.5.2-1.x86_64.rpm
sudo dnf install ./webcord-4.5.2-1.x86_64.rpm -y
rm webcord-4.5.2-1.x86_64.rpm

# Install CLI Packages
echo -e "${GREEN}Installing CLI packages...${NC}"
sudo dnf install htop neovim gh autojump cmatrix hugo rclone tldr tree trash-cli powertop qalculate java python3-pip sudo dnf install dbus-glib mangohud wine winetricks papirus-icon-theme wireguard-tools syncthing libwebp-devel -y

# Easyeffects Presets
echo -e "${GREEN}Installing easyeffects presets...${NC}"
mkdir -p ~/.config/easyeffects/output
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)"

# Adding the Dotfiles
prompt_for_dotfiles() {
    read -p "Do you want to add my Dotfiles? (y/n): " choice
    case "$choice" in 
        y|Y ) echo -e "${GREEN}Adding the Dotfiles...${NC}" ;;
        n|N )
            echo -e "${YELLOW}Aborted by user. Exiting the script.${NC}"
            echo -e "${GREEN}Installation completed successfully.${NC}"
            echo -e "${GREEN}You should now reboot.${NC}"
            exit 1
            ;;
        * )
            echo -e "${RED}Invalid choice. Exiting the script.${NC}"
            echo -e "${GREEN}Installation completed successfully.${NC}";
            echo -e "${GREEN}You should now reboot.${NC}"
            exit 1
            ;;
    esac
}
prompt_for_dotfiles

# Install Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
mkdir -p ~/.local/share/fonts/JetBrainsMono/
unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono/
rm JetBrainsMono.zip 
fc-cache -fv

# Install Bibata Cursor theme
wget https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.4/Bibata-Modern-Classic.tar.xz
sudo mkdir -p /usr/share/icons/Bibata-Modern-Classic/
sudo tar -xf Bibata-Modern-Classic.tar.xz -C /usr/share/icons/
sudo sed -i "s/Inherits=.*/Inherits=Bibata-Modern-Classic/" "/usr/share/icons/default/index.theme"
rm Bibata-Modern-Classic.tar.xz

# Install Nordic Darked theme
wget https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic-darker.tar.xz
mkdir -p ~/.local/share/themes/Nordic-darker/
tar -xf Nordic-darker.tar.xz -C ~/.local/share/themes/
rm Nordic-darker.tar.xz

cp -r DotFiles/hypr/ ~/.config/
cp -r DotFiles/kitty/ ~/.config/
cp -r DotFiles/neofetch/ ~/.config/
cp -r DotFiles/rofi/ ~/.config/
cp -r DotFiles/swaylock/ ~/.config/
cp -r DotFiles/waybar/ ~/.config/
cp -r DotFiles/mako/ ~/.config/
cp -r DotFiles/gtk-3.0/ ~/.config/
cp DotFiles/bashrc ~/.bashrc
cp DotFiles/starship.toml ~/.config/.
cp DotFiles/low-power.sh ~/.config/.
cp DotFiles/nord.jpeg ~/.config/wallpaper

# Change Plymouth
sudo dnf install plymouth-theme-spinner -y
sudo plymouth-set-default-theme spinner -R

# Grub theme
wget https://github.com/Jacksaur/CRT-Amber-GRUB-Theme/releases/download/1.1/CRT-Amber-Theme.zip
sudo mkdir -p /boot/grub2/theme/CRT-Amber-Theme 
sudo unzip -o CRT-Amber-Theme.zip -d /boot/grub2/theme/CRT-Amber-Theme
sudo sed -i -e 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=3/' \
            -e 's/^GRUB_TERMINAL_OUTPUT=/#GRUB_TERMINAL_OUTPUT=/' \
            -e '$ a GRUB_THEME="/boot/grub2/theme/CRT-Amber-Theme/CRT-Amber-GRUB-Theme/theme.txt"' \
            /etc/default/grub
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
rm CRT-Amber-Theme.zip

echo -e "${GREEN}Installation completed successfully.${NC}"
echo -e "${GREEN}You should now reboot.${NC}"
