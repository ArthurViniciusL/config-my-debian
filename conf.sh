#!/bin/bash

#v 4.0.3

startMain() {

    updateSystem

    read -p "Hidden GRUB? (y/n): " hidden_grub
    if [[ "$hidden_grub" == "y" || "$hidden_grub" == "Y" ]]; then
        hiddenGrub    
    fi [[""]] 
    
    read -p "Install nvidia drivers? (y/n): " nvidia_drivers
    if [[ "$nvidia_drivers" == "y" || "$nvidia_drivers" == "Y" ]]; then
        installNvidiaDrivers
    fi

    # preiorizar programas em flatpak?
    installFlatpak

    installDevTools

    installApps
    removeApps

    # installFlatpakPrograms

    echo 'Reboot this PC...'
}

updateSystem() {

    echo "Fazendo atualizacoes..."
    sudo apt update
    sudo apt upgrade

    clear
}

addSudoUser() {

    read -p "Add super user? (y/n): " choice

    if [[ "$choice" == "y" || "$choice" == "Y" || "$choice" == "yes" || "$choice" == "YES" ]]; then

        echo "Installing sudo..."

        apt install sudo -y

        clear

	read -p "Enter your username: " username

        echo "Adding $username to sudo group..."
        sudo usermod -aG sudo "$username"

        sudo cp /etc/sudoers /etc/sudoers.bak
        echo "$username   ALL=(ALL:ALL) ALL" | sudo EDITOR='tee -a' visudo

        echo "User $username added as sudoer successfully!"

        sudo nano /etc/sudoers
    fi
    
    clear
    
    apt update
    apt upgrade

    clear
}

installApps() {    
    echo "Instalando pacotes do apt..."
    
    appsFromRepository=("gnome-shell-pomodoro" "gnome-console" "gnome-shell-extension-manager" "obs-studio" "gimp" "inkscape" "kdenlive" "touchegg" "google-chrome-stable" "gnome-shell-extension-gsconnect" "chromium");

    for appsFromRepository in "${appsFromRepository[@]}"
    do
      sudo apt-get install -y $appsFromRepository
    done
    
    clear
    
    installSpotify
    installFirefox

    #Install insomnia
    wget -O insomnia.deb "https://updates.insomnia.rest/downloads/ubuntu/latest?&app=com.insomnia.app&source=website"
    sudo dpkg -i insomnia.deb
    rm insomnia.deb

    clear
}

removeApps() {
    
    echo "Removendo alguns apps que eu nao uso..."

    appsUnsed=("firefox-esr" "evolution" "zutty" "rhythmbox" "gnome-contacts" "gnome-maps" "vlc" "kdeconnect" "totem" "systemsettings")

    for appsUnsed in "${appsUnsed[@]}"
    do
	sudo apt remove --purge -y $appsUnsed
    done

    clear

    echo "Removendo jogos..."

    jogos=("quadrapassel" "gnome-2048" "gnome-mines" "gnome-sudoku" "four-in-a-row" "iagno" "swell-foop" "gnome-klotski" "five-or-more" "gnome-robots" "gnome-tetravex" "gnome-taquin" "lightsoff" "gnome-mahjongg" "aisleriot" "gnome-nibbles" "gnome-chess" "tali" "hitori")
 
    for jogos in "${jogos[@]}"
    do
	sudo apt remove -y $jogos
    done

    clear
}

installSpotify() {
   
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

    sudo apt update 
    sudo apt install spotify-client -y

    clear
}

installDevTools() {
    echo "Instalando pacotes para desenvolvimento..."

    packages=( "wget" "curl" "git" "nodejs npm" "default-jdk" "default-jre")
    
    for packages in "${packages[@]}"
    do
	    sudo apt-get install -y $packages
    done

    clear

    echo "Instalandos IDE's..."

    visualStudioCode
    intelliJIdea

    clear

    echo "Installing Docker..."
    installDocker

    read -p "Install Gemini CLI? (y/n): " gemini_cli
    if [[ "$gemini_cli" == "y" || "$gemini_cli" == "Y" ]]; then
        echo "Installing Gemini CLI..."
        npm install -g @google/gemini-cli
    fi

    clear
}

visualStudioCode() {

    echo "Installing Visual Studio Code..."
    
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

    sudo apt update
    sudo apt install code

    clear
}

intelliJIdea() {

    echo "Instalando o Intellij Idea Community..."

    curl -s https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc | gpg --dearmor | sudo tee /usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg] http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" | sudo tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null

    sudo apt update
    
    sudo apt install -y intellij-idea-community

    clear
}

installDocker() {

    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    clear

    echo "Installing docker packages..."

    sudo apt-get install installDocker-ce installDocker-ce-cli containerd.io installDocker-buildx-plugin installDocker-compose-plugin -y

    docker compose version

    clear
}

installFirefox() {
 sudo install -d -m 0755 /etc/apt/keyrings
 sudo apt install wget -y

 wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

 gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'

 echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null

 echo '
 	Package: * 
	Pin: origin packages.mozilla.org
	Pin-Priority: 1000
      ' | sudo tee /etc/apt/preferences.d/mozilla


 sudo apt-get update && sudo apt-get install firefox
}

installFlatpak() {
    echo "Installing flatpak support..."

    sudo apt install -y flatpak
    apt install -y gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    clear
}

installFlatpakPrograms() {
    echo "Installing flatpaks..."

    appsFlatpak=("flathub fr.handbrake.ghb" "flathub io.github.mrvladus.List" "flathub md.obsidian.Obsidian" "flathub org.gabmus.hydrapaper" "flathub org.gnome.design.IconLibrary" "flathub com.github.huluti.Curtail" "flathub com.github.flxzt.rnote" "flathub com.github.unrud.VideoDownloader" "flathub com.discordapp.Discord" "flathub io.bassi.Amberol" "flathub io.dbeaver.DBeaverCommunity")

    for appsFlatpak in "${appsFlatpak[@]}"
    do
	flatpak install -y $appsFlatpak
    done

    clear
}

installNvidiaDrivers() {
    echo "Installing nvidia drivers..."

    # apt install nvidia-detect -y && clear && nvidia-detect && clear
    # apt install nvidia-driver firmware-misc-nonfree nvidia-cuda-toolkit

    # add Nvidia repository for Debian
    wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
    sudo dpkg -i cuda-keyring_1.1-1_all.deb
    sleep 1
    
    sudo apt-get update
    sudo apt-get install cuda-drivers

    sudo rm -f cuda-keyring_1.1-1_all.deb
}

// TODO melhorar essa parte da escrita no arquivo:

hiddenGrub() {
  
    sudo tee /etc/default/grub > /dev/null << 'EOF'
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
GRUB_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""

# If your computer has multiple operating systems installed, then you
# probably want to run os-prober. However, if your computer is a host
# for guest OSes installed via LVM or raw disk devices, running
# os-prober can cause damage to those guest OSes as it mounts
# filesystems to look for things.
#GRUB_DISABLE_OS_PROBER=false

# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"

# Uncomment to disable graphical terminal
GRUB_TERMINAL=console

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command `vbeinfo'
GRUB_GFXMODE=1920x1080
GRUB_GFXPAYLOAD_LINUX=1920x1080

# Uncomment if you don't want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true

# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"

# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"

# Save the file to confirm...

EOF

    sudo nano /etc/default/grub
    sudo update-grub
    
    clear
}

startMain
