#!/bin/bash
#v 1.0.6

startMain() {
    atualizacoes
    addSudoUser
    installDevThings
    installApps
    removenApps
    installSpotify
    installVsCode
    installInstellijIdeaCommunity
    installDriversNvidia
    installFlatpak
    installFlatpakPrograms
}

atualizacoes() {
    echo "Fazendo atualizacoes..."
    sudo apt-get update
    sudo apt-get upgrade

    clear
}

addSudoUser() {

    echo "Instalando o sudo..."

    #su --login

    sudo apt install -y sudo
    
    clear
        
    echo "Adicionando usuário sudo..."

    userName=$USER
    
    sudo nano /etc/sudoers
    echo "$userName ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers

 
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
    
    appsFromRepository=("gnome-console" "gnome-shell-pomodoro" "obs-studio" "pinhole" "gimp" "inkscape" "pitivi");
        
    for appsFromRepository in "${appsFromRepository[@]}"
    do
      sudo apt-get install -y $appsFromRepository
    done
    
    installSpotify
    installVsCode
    installInstellijIdeaCommunity

    clear
}

removenApps() {
    
    echo "Removendo alguns apps que eu nao uso..."

    appsUnsed=("cheese" "evolution" "zutty" "shotwell" "rhythmbox" "gnome-contacts" "gnome-maps" "vlc" "gnome-terminal")

    for appsUnsed in "${appsUnsed[@]}"
    do
        sudo apt remove -y $appsUnsed
    done

    clear

    echo "Removendo jogos..."

    # completar a lista de pacotes
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
}

installVsCode() {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install -y code
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

    # Adicionando as linhas no final do arquivo
    echo "# Debian Sid" | sudo tee -a /etc/apt/sources.list
    echo "deb http://deb.debian.org/debian/ sid main contrib non-free non-free-firmware" | sudo tee -a /etc/apt/sources.list
        
    # Use 'Ctrl + O' para salvar e 'Ctrl + X' para sair do nano
    echo -e "\x1B\x5B\x31\x3B\x35\x48\x0D\x0A\x1B\x5B\x31\x3B\x35\x41\x1B\x5B\x31\x3B\x35\x43" | sudo nano /etc/apt/sources.list

    sudo apt update
    sudo apt install -y nvidia-driver firmware-misc-nonfree

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

    appsFlatpak=("flathub io.github.flattool.Warehouse" "flathub io.github.shiftey.Desktop" "flathub com.getpostman.Postman" "md.obsidian.Obsidian" "flathub io.github.mrvladus.List" "de.haeckerfelix.Fragments")

    for appsFlatpak in "${appsFlatpak[@]}"
    do
        flatpak install -y $appsFlatpak
    done

    clear
}

showDebianLogo() {
    echo"                    xWW'   .                       "
    echo"               ,WNXK00000KXKKKKXXNW'               "
    echo"            xNX00000000000000000000KK0KNX:         "
    echo"         lNK00000000l             00000000XN       "
    echo"       dX0000000                     c000000KK     "
    echo"      N0000000'                        ;000000X,   "
    echo"  '  X0000;                              x00000K:  "
    echo"   kX000'                                 l000. o  "
    echo"  o000c                  .WWWWWo           d00Xc.  "
    echo".;K000                ;NK         ,        '000c   "
    echo" K000                Wl                     000k   "
    echo",000.               X,                      O00Kl  "
    echo"'000               0d                ;      000x   "
    echo",00k               0d                       O0k    "
    echo",00o               x0.             ..      o00'    "
    echo",00o               .0K                    NK0'     "
    echo".000                ,0N.                'N0x       "
    echo" 000,              ;; ,KW.           .ONKl         "
    echo" l00d                 ,l 0XNWN  :WWNXKd            "
    echo"  000o                    K.                       "
    echo"  '000KN                                           "
    echo"   ;000K.                                          "
    echo"    ,000O                                          "
    echo"     .000K                                         "
    echo"       o00X,                                       "
    echo"         00KK                                      "
    echo"           00XW,                                   "
    echo"             c0KX                                  "
    echo"                ;KXWX                              "
    echo"                     KNM                           "
    echo"                                                   "
}

showDebianLogo
startMain
sudo reboot