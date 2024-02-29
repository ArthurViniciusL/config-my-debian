#!/bin/bash

#v 2.0.4

startMain() {
    atualizacoes
    installDevThings
    installApps
    removenApps
    installDriversNvidia
    installApps
    installFlatpak
    installFlatpakPrograms
    addSudoUser
}

atualizacoes() {
    echo "Fazendo atualizacoes..."
    sudo apt-get update
    sudo apt-get upgrade

    clear
}

addSudoUser() {
        
    echo "Adicionando usuário sudo..."

    
    sudo nano /etc/sudoers
    
    clear

    echo "Instalando o sudo..."   
    userName=$USER
    apt install -y sudo
    adduser $userName sudo
    
    clear
    
    apt update
    apt upgrade

    clear
}

installDevThings() {
    echo "Instalando pacotes para desenvolvimento"

    devThings=( "curl" "git" "nodejs npm" "default-jdk" "default-jre")
    
    for devThings in "${devThings[@]}"
    do
        sudo apt-get install -y $devThings
    done
    
    clear
}

installApps() {    
    echo "Instalando pacotes em .deb..."
    
    appsFromRepository=("gnome-console" "gnome-shell-pomodoro" "obs-studio" "pinhole" "gimp" "inkscape" "kdenlive");
        
    for appsFromRepository in "${appsFromRepository[@]}"
    do
      sudo apt-get install -y $appsFromRepository
    done
    
    clear
    
    installSpotify
    installVsCode
    installInstellijIdeaCommunity

    clear
    cd /home/arthur
    echo "Aplicando estilos no Firefox"
    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
    
    clear
}

removenApps() {
    
    echo "Removendo alguns apps que eu nao uso..."

    appsUnsed=("cheese" "evolution" "zutty" "shotwell" "rhythmbox" "gnome-contacts" "gnome-maps" "vlc" "gnome-terminal" "kdeconnect")

    for appsUnsed in "${appsUnsed[@]}"
    do
        sudo apt remove -y $appsUnsed
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
    # Instala o spotify .deb
    sudo curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt-get update
    sudo apt-get install -y spotify-client

    clear
}

installVsCode() {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install -y code

    clear
}

installInstellijIdeaCommunity() {
    # Instala o IntelliJ community
    curl -s https://s3.eu-central-1.amazonaws.com/jetbrains-ppa/0xA6E8698A.pub.asc | gpg --dearmor | sudo tee /usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg > /dev/null
    echo "deb [signed-by=/usr/share/keyrings/jetbrains-ppa-archive-keyring.gpg] http://jetbrains-ppa.s3-website.eu-central-1.amazonaws.com any main" | sudo tee /etc/apt/sources.list.d/jetbrains-ppa.list > /dev/null
    sudo apt update
    sudo apt install  -y intellij-idea-community

    clear
}

installDriversNvidia() {
    
    echo "Instalando drivers da NVIDIA..."

    sudo nano /etc/apt/sources.list
    
    echo "Atualizando pacotes"
    sudo apt-get update
    sudo apt-get upgrade

    sudo apt-get install nvidia-detect linux-headers-amd64
    sudo apt-get install nvidia-driver firmware-misc-nonfree
    sudo apt-get install nvidia-cuda-dev nvidia-cuda-toolkit libnvidia-encode1


    clear
}

installFlatpak() {
    echo "Instalando o suporte a flatpak..."

    sudo apt install -y flatpak
    apt install -y gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    clear
}

installFlatpakPrograms() {
    echo "Instalando flatpaks..."

    appsFlatpak=("flathub io.github.flattool.Warehouse" "flathub fr.handbrake.ghb" "flathub io.github.shiftey.Desktop" "flathub com.getpostman.Postman" "flathub io.github.mrvladus.List" "de.haeckerfelix.Fragments" "flathub md.obsidian.Obsidian" "flathub org.gabmus.hydrapaper")

    for appsFlatpak in "${appsFlatpak[@]}"
    do
        flatpak install -y $appsFlatpak
    done

    clear
}

startMain
sudo reboot
