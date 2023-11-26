#!/bin/bash

main() {
    func
    
}

func() {
    echo "Removendo jogos..."

    jogos=("quadrapassel" "gnome-2048" "gnome-mines" "gnome-sudoku" "fire-in-a-row" "iagno")
 
    for jogos in "${jogos[@]}"
    do
        echo "jogo: $jogos"
    done
}

main