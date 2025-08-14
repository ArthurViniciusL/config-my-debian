#!/bin/bash

#v 4.0.3

startMain() {
    updateSystem
    installFlatpak
    hiddenGrub    
    addSudoUser
    installNvidiaDrivers

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

    echo "Adicionando usuário sudo..."
    
    sudo nano /etc/sudoers
    
    clear

    echo "Instalando o sudo..."

    apt install sudo -y
    adduser arthur sudo
    
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

    echo "Instalandos o Docker..."
    docker

    echo "Instalando o Gemini CLI..."
    
    npm install -g @google/gemini-cli

    clear
}

visualStudioCode() {

    echo "Instalando o Visual Studio Code..."
    
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

docker() {

    # Add Docker's official GPG key:
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

    echo "Instalando os pacotes docker..."

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

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
    echo "Instalando o suporte a flatpak..."

    sudo apt install -y flatpak
    apt install -y gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    clear
}

installFlatpakPrograms() {
    echo "Instalando flatpaks..."

    appsFlatpak=("flathub fr.handbrake.ghb" "flathub io.github.mrvladus.List" "flathub md.obsidian.Obsidian" "flathub org.gabmus.hydrapaper" "flathub org.gnome.design.IconLibrary" "flathub com.github.huluti.Curtail" "flathub com.github.flxzt.rnote" "flathub com.github.unrud.VideoDownloader" "flathub com.discordapp.Discord" "flathub io.bassi.Amberol")

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

hiddenGrub() {
  sudo nano /etc/default/grub
  sudo update-grub
}

startMain
