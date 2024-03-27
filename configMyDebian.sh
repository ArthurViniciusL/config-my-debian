#!/bin/bash

#v 2.0.5

startMain() {
    atualizacoes
    installDevThings
    installApps
    removeApps
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
    
    appsFromRepository=("gnome-shell-pomodoro" "obs-studio" "pinhole" "gimp" "inkscape" "kdenlive");
        
    for appsFromRepository in "${appsFromRepository[@]}"
    do
      sudo apt-get install -y $appsFromRepository
    done
    
    clear
    
    installSpotify
    installVsCode
    installInstellijIdeaCommunity
    installFirefox

    clear
    cd /
    cd /home/arthur/.mozilla/
    echo "Aplicando estilos no Firefox"
    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
    
    clear
}

removeApps() {
    
    echo "Removendo alguns apps que eu nao uso..."

    appsUnsed=("cheese" "firefox-esr" "evolution" "zutty" "shotwell" "rhythmbox" "gnome-contacts" "gnome-maps" "vlc" "kdeconnect")

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

installFirefox() {
    sudo install -d -m 0755 /etc/apt/keyrings
    apt-get install wget

    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
    gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nO fingerprint da chave corresponde ("$0").\n"; else print "\nFalha na verificação: o fingerprint ("$0") não corresponde ao esperado.\n"}'
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
    echo '
    Package: *
    Pin: origin packages.mozilla.org
    Pin-Priority: 1000
    ' | sudo tee /etc/apt/preferences.d/mozilla
    sudo apt-get update && sudo apt-get install firefox
}

installDriversNvidia() {
    
    sudo nano /etc/apt/sources.list
    
    echo "Atualizando pacotes..."
    sudo apt-get update
    sudo apt-get upgrade
    
    clear

    echo "Instalando drivers da NVIDIA..."
    sudo apt-get install nvidia-detect linux-headers-amd64 -y
    sudo apt-get install nvidia-driver firmware-misc-nonfree -y
    sudo apt-get install nvidia-cuda-dev nvidia-cuda-toolkit libnvidia-encode1 -y

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

    appsFlatpak=("flathub fr.handbrake.ghb" "flathub io.github.shiftey.Desktop" "flathub com.getpostman.Postman" "flathub io.github.mrvladus.List" "flathub md.obsidian.Obsidian" "flathub org.gabmus.hydrapaper" "flathub org.gnome.design.IconLibrary" "flathub com.github.huluti.Curtail" "flathub io.github.Figma_Linux.figma_linux")

    for appsFlatpak in "${appsFlatpak[@]}"
    do
        flatpak install -y $appsFlatpak
    done

    clear
}

startMain
sudo reboot
