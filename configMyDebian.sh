#!/bin/bash

#v 2.0.6

startMain() {
    atualizacoes
    installDevThings
    installApps
    removeApps
    installFlatpak
    installFlatpakPrograms
    installNvidiaDrivers
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
#    userName=$USER
#    clear
#    echo username
 
    apt install sudo -y
    adduser arthur sudo
    
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

    installDocker
    
    clear
}

installDocker() {

    echo "Instalando o docker..."
    # Add Docker's official GPG key:

    sudo apt install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc


    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update

    #Install docker packges
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

    clear

    echo "Instalando o docker compose..."

    sudo apt install docker-compose-plugin -y
    docker compose version

}

installApps() {    
    echo "Instalando pacotes do apt..."
    
    appsFromRepository=("gnome-shell-pomodoro" "obs-studio" "gimp" "inkscape" "kdenlive" "touchegg" "google-chrome-stable" "gnome-shell-extension-gsconnect" "insomnia");

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
    # Instala o spotify .deb
	curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
	echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
	sudo apt-get update && sudo apt-get install spotify-client -y

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

#installFirefox() {
#    sudo apt-get install wget
    
#    sudo install -d -m 0755 /etc/apt/keyrings
#    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
#    gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nO fingerprint da chave corresponde ("$0").\n"; else print "\nFalha na verificação: o fingerprint ("$0") não corresponde ao esperado.\n"}'
#    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
#    echo '
#Package: *
#Pin: origin packages.mozilla.org
#Pin-Priority: 1000
#' | sudo tee /etc/apt/preferences.d/mozilla

#	sudo apt-get update && sudo apt-get install firefox -y
	
#    clear
    
#    cd /
#    cd /home/arthur/.mozilla/
#    echo "Aplicando estilos no Firefox"
#    curl -s -o- https://raw.githubusercontent.com/rafaelmardojai/firefox-gnome-theme/master/scripts/install-by-curl.sh | bash
    
#}

installFlatpak() {
    echo "Instalando o suporte a flatpak..."

    sudo apt install -y flatpak
    apt install -y gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    clear
}

installFlatpakPrograms() {
    echo "Instalando flatpaks..."

    appsFlatpak=("flathub fr.handbrake.ghb" "flathub io.github.shiftey.Desktop" "flathub io.github.mrvladus.List" "flathub md.obsidian.Obsidian" "flathub org.gabmus.hydrapaper" "flathub org.gnome.design.IconLibrary" "flathub com.github.huluti.Curtail" "flathub org.gnome.Totem" "flathub com.github.flxzt.rnote" "flathub com.github.unrud.VideoDownloader" "flathub io.github.zen_browser.zen" "flathub com.discordapp.Discord")

    for appsFlatpak in "${appsFlatpak[@]}"
    do
	flatpak install -y $appsFlatpak
    done

    clear
}

installNvidiaDrivers() {
    echo "Instalando Drivers da Nvidia..."

    apt install nvidia-detect -y && clear && nvidia-detect && clear
    
    apt install nvidia-driver firmware-misc-nonfree nvidia-cuda-toolkit

 }

startMain
sudo reboot
