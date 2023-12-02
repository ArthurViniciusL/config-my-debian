<h1>Autor: Arthur Vinicius</h1>
<h2>Sobre: https://arthurviniciusl.github.io/arthur-vs-lucena/</h2>

<p>Sinta-se a vontade para testar e até mesmo melhorar o script de pós-instalação. Mas lembre-se de manter os créditos do autor original.</p>

<h1>Configurações</h1>

<h3>Rodando o script:</h3>
<ol>
    <li>Abra o terminal.</li>
    <li>Digite:
        <pre><code>su</code></pre>
    </li>
    <li>Informe a senha root:
        <pre><code>1234</code></pre>
     </li>
    <li>Clone o repositório com:
        <pre><code>git clone https://github.com/ArthurViniciusL/my-shells-scripts.git</code></pre>
    </li>
    <li>Entre no diretório baixado:
        <pre><code>cd my-shells-scripts</code></pre>
    </li>
    <li>Permita a execução do arquivo:
        <pre><code>chmod +x configMyDebian.sh</code></pre>
    </li>
    <li>Execute o script:
        <pre><code>/configMyDebian.sh</code></pre>
    </li>
    <li>Adicione o usuário ao sudo Abaixo da linha "root ALL=(ALL:ALL) ALL".
        <pre><code>seu_nome_de_usuario ALL=(ALL:ALL) ALL</code></pre>
     </li>
    <li>Salve o arquivo apertando o atalho: ctrl+o</li>
    <li>Feche o arquivo apertando o atalho: ctrl+x</li>
    <li>Deixe o configMyDebian trabalhar.</li>
</ol>

<h3>Para apenas testar o script utilize o virtualbox</h3>
    
<ol>
    <li>Instale o virtualbox na sua maquina.</li>
    <li>Importe o arquivo: debian-12-vm.ova</li>
    <li>Execute a maquina virtual.</li>
    <li>Faça login no Debia com a senha: 1234</li>
</ol>
