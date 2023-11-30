#Autor: Arthur Vinicius
#Sobre: https://arthurviniciusl.github.io/arthur-vs-lucena/

Sintas a vontade para testar e até mesmo melhorar o script de pós-instalação. Mas lembre-se de manter os créditos do autor original.

####Senhas:
    Senha de login: 1234
    senha root: 1234
    
####Rodando o script (dentro da VM):
    - Abra o terminal.
    - Digite:
        su
    - Informe a senha root (1234).
    - Clone o repositório com:
        git clone https://github.com/ArthurViniciusL/my-shells-scripts.git
    - Entre no diretório baixado:
        cd my-shells-scripts
    - Permita a execução do arquivo:
        chmod +x configMyDebian.sh
    - Execute o script:
        ./configMyDebian.sh
    - Adicione o usuário ao sudo Abaixo da linha "root ALL=(ALL:ALL) ALL" 
        digite: arthur-deb ALL=(ALL:ALL) ALL
    - Salve o arquivo apertando o atalho: ctrl+o
    - Feche o arquivo apertando o atalho: ctrl+x
    - Deixe o configMyDebian trabalhar.
