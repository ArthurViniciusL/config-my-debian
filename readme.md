<h1>Autor: Arthur Vinicius</h1>
<h2>Sobre: https://arthurviniciusl.github.io/arthur-vs-lucena/</h2>

<p>Sinta-se a vontade para testar, melhorar e até mesmo adaptar o script de pós-instalação. Mas lembre-se de manter os créditos do autor original.</p>

<h1>Configurações</h1>

<h3>Rodando o script:</h3>
<ol>
    <li>Abra o terminal.</li>
    <br>
    <li>Digite:
        <pre><code>su --login</code></pre>
    </li>
    <br>
    <li>Informe a sua senha root.</li>
    <br>
    <li>Clone o repositório com:
        <pre><code>git clone https://github.com/ArthurViniciusL/config-my-debian.git</code></pre>
    </li>
    <br>
    <li>Entre no diretório baixado:
        <pre><code>cd config-my-debian</code></pre>
    </li>
    <br>
    <li>Permita a execução do arquivo:
        <pre><code>chmod +x configMyDebian.sh</code></pre>
    </li>
    <br>
    <li>Execute o script:
        <pre><code>./configMyDebian.sh</code></pre>
    </li>
    <br>
    <li>Deixe o configMyDebian trabalhar.</li>
    <br>
    <li>Quando estiver no diretório: /etc/apt/sources.list.
        <ol type="1">
            <br>
            <li>Salve o arquivo apertando o atalho: ctrl+o</li>
            <li>Feche o arquivo apertando o atalho: ctrl+x</li>
        </ol>
    </li>
    <br>
    <li>Quando estiver no diretório: /etc/sudors.
        <br>
        <ol type="1">
            <br>
            <li>Adicione o usuário ao sudo Abaixo da linha "root ALL=(ALL:ALL) ALL".
                <pre><code>seu_nome_de_usuario ALL=(ALL:ALL) ALL</code></pre>
            </li>
            <br>
            <li>Salve o arquivo apertando o atalho: ctrl+o</li>
            <br>
            <li>Feche o arquivo apertando o atalho: ctrl+x</li>
        </ol>
     </li>
    <br>
</ol>
<hr>
<h3>Para apenas testar o script utilize o virtualbox</h3>
<ol>
    <li>Faça download da maquina virtual: <a href="https://drive.google.com/drive/folders/1Uu_7uJpK82PbeXWs8vP1wMiNl2KW0O6F?usp=sharing" target="_blank">debian-12-vm.ova</a></li>
    <li>Instale o virtualbox na sua maquina.</li>
    <li>Importe o arquivo: debian-12-vm.ova</li>
    <li>Execute a maquina virtual.</li>
    <li>Faça login no Debia com a senha: 1234</li>
</ol>
