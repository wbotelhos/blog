---
date: 2012-04-04T00:00:00-03:00
description: "Amazon EC2 com Java, MySQL e Tomcat"
tags: ["amazon", "aws", "ec2", "java", "mysql", "tomcat"]
title: "Amazon EC2 com Java, MySQL e Tomcat"
---

<img class="align-center" title="Amazon EC2" src="http://farm9.staticflickr.com/8018/7692541136_b9d5276bd5.jpg" alt="Amazon EC2" width="500" height="250" />

Com a popularização do [Cloud Computing](http://en.wikipedia.org/wiki/Cloud_computing) foram surgindos mais e mais empresas disponibilizando bons serviços sobre o assunto. Aqui no Brasil já tínhamos a conhecida [Locaweb](http://www.locaweb.com.br/solucoes/cloud-computing.html), que alguns diziam ser um Cloud Manual, diga-se de passagem. Outras empresas lá fora como o [Heroku](http://www.heroku.com) ficaram bem conhecidas, assim como a [Amazon](http://aws.amazon.com/ec2) que já vinha disponibilizando o melhor dos serviços, porém o [preço](http://aws.amazon.com/ec2/pricing) e o [ping](http://pt.wikipedia.org/wiki/Ping) as vezes deixavam a desejar. Mas para a felicidade de todos a [Amazon passou a ter servidores aqui em São Paulo](http://aws.amazon.com/about-aws/whats-new/2011/12/14/announcing-the-south-america-sao-paulo-region), além de [ótimos preço](http://aws.amazon.com/pt/ec2/pricing).

<div style="color: #369; font: bold 16px arial; margin-bottom: 10px; margin-top: 25px;">Objetivo:</div>

Criar uma instância na Amazon EC2 e instalar o Java, MySQL e o Tomcat, deixando tudo preparado para rodarmos uma aplicação.

<div style="color: #369; font: bold 16px arial; margin-bottom: 10px; margin-top: 25px;">Criando a VM:</div>

Primeiramente [crie sua conta no EC2](http://aws.amazon.com/ec2) e em seguida acesso o [console administrativo](https://console.aws.amazon.com/ec2/home?region=sa-east-1) EC2 em português da região sul:

<a href="http://www.flickr.com/photos/wbotelhos/7692542060" target="_blank">
<img class="align-center" title="Lauch Instance" src="http://farm9.staticflickr.com/8161/7692542060_c89aa53fb1.jpg" alt="Lauch Instance" width="485" height="179" />
</a>

Escolha o Classic Wizard e dê continuidade:

<a href="http://www.flickr.com/photos/wbotelhos/7692541044" target="_blank">
<img class="align-center" title="Classic Wizard" src="http://farm8.staticflickr.com/7273/7692541044_dae81fc031.jpg" alt="Classic Wizard" width="500" height="302" />
</a>

Você poderá escolher instâncias já pré configuradas com alguns aplicativos ou uma do zero. Vá na guia **Community AMIs** e pesquise pelo termo "amazon/amzn-ami" e terá uma lista dos SOs disponibilizados pela própria Amazon. Iremos escolher a última versão x64 disponível:

<a href="http://www.flickr.com/photos/wbotelhos/7692541264" target="_blank">
<img class="align-center" title="Community AMIs" src="http://farm9.staticflickr.com/8150/7692541264_3b495d0238.jpg" alt="Community AMIs" width="500" height="325" />
</a>

Na próxima tela só iremos escolher uma área entre a A ou B de São Paulo para rodarmos a VM. Preste atenção para não modificar o **Instance Type**, pois apenas o **Micro** é gratuito. A não ser que queira algo mais robusto e pague por isto.

<a href="http://www.flickr.com/photos/wbotelhos/7692541868" target="_blank">
<img class="align-center" title="Instance Details" src="http://farm9.staticflickr.com/8154/7692541868_dd49f88c5f.jpg" alt="Instance Details" width="500" height="341" />
</a>

Na próxima tela deixe como esta e avance:

<a href="http://www.flickr.com/photos/wbotelhos/7692540878" target="_blank">
<img class="align-center" title="Advanced Instance" src="http://farm9.staticflickr.com/8147/7692540878_955260e90a.jpg" alt="Advanced Instance" width="500" height="339" />
</a>

Agora podemos adicionar tags para identificar melhor a nossa instância. Poderíarmos adicionar até 10, porém vamos apenas dar um nome. Neste caso **mockr**, o nome da nossa aplicação:

<a href="http://www.flickr.com/photos/wbotelhos/7692540718" target="_blank">
<img class="align-center" title="Tag Option" src="http://farm9.staticflickr.com/8430/7692540718_474934af0e.jpg" alt="Tag Option" width="500" height="342" />
</a>

Iremos criar a chave de acesso à instância, ou seja, você só poderá se conectar ao servidor que esta criando se obtiver esta chave. Guarde-a com segurança! Você também tem opção de escolher uma já criada ou não usar nenhuma, bad! Dê um nome para a sua nova chave e clique no link para gerá-la e fazer o download:

<a href="http://www.flickr.com/photos/wbotelhos/7692541946" target="_blank">
<img class="align-center" title="Key Pair" src="http://farm9.staticflickr.com/8427/7692541946_9483681867.jpg" alt="Key Pair" width="500" height="338" />
</a>

Além da chave também devemos criar um grupo de segurança que determina quais portas serão liberadas. Iremos criar um novo grupo em vez de usar o default. Daremos um nome, descrição e escolheremos quais serviços iremos liberar, tendo a opção de se escolher um pré existente no combobox **Create a new rule** ou entrando com os valores manualmente. Precisaremos da porta do SSH, HTTP, MySQL e a do Tomcat:

<a href="http://www.flickr.com/photos/wbotelhos/7692542286" target="_blank">
<img class="align-center" title="Security Group" src="http://farm8.staticflickr.com/7140/7692542286_ce94ac24eb.jpg" alt="Security Group" width="500" height="339" />
</a>

Aparecerá uma tela para revisão dos dados. Click em Lauch e a instância irá subir:

<a href="http://www.flickr.com/photos/wbotelhos/7692542158" target="_blank">
<img class="align-center" title="Review" src="http://farm8.staticflickr.com/7125/7692542158_4b425f1d9d.jpg" alt="Review" width="500" height="339" />
</a>

Uma última tela confirmando que a instância foi configurada com sucesso irá aparecer. Click em close e visualize o seu console EC2 no qual você pode dar um nome para a instância, checar se esta sendo executada e clicando sobre a mesma, visualizar detalhes como o DNS público. Inicialmente o **Status Checks** estará como *initializing*, mas rapidamente estará checkado:

<a href="http://www.flickr.com/photos/wbotelhos/7692541446" target="_blank">
<img class="align-center" title="Console" src="http://farm9.staticflickr.com/8429/7692541446_dff2a4eeb1.jpg" alt="Console" width="500" height="313" />
</a>

O conjunto formado pela Key Pair mais o DNS público liberam o acesso ao servidor, porém digitar ou até mesmo decorar esse DNS é inviável. Para facilitar a nossa vida, podemos vincular um IP a este endereço, sendo que é permitido apenas **um** IP **vinculado** para ser free. Qualquer IP a mais não vinculado será cobrado.

Vá no menu **Elastic IP** click em **Allocate New Address**, confirmando a alocação do IP:

<a href="http://www.flickr.com/photos/wbotelhos/7692541630" target="_blank">
<img class="align-center" title="Elastic IP" src="http://farm8.staticflickr.com/7246/7692541630_5c28c2e108.jpg" alt="Elastic IP" width="500" height="250" />
</a>

Em seguida temos que associar este IP à nossa instância clicando no botão **Associate Address** e escolhendo a instância. Se você não deu um nome para a sua instância, apenas o nome ilegível irá aparecer no combobox:

<a href="http://www.flickr.com/photos/wbotelhos/7692541758" target="_blank">
  <img class="align-center" title="Elastic IP Associate" src="http://farm8.staticflickr.com/7277/7692541758_ef83e84d8c.jpg" alt="Elastic IP Associate" width="500" height="248" />
</a>

> Lembre-se que este IP não é dinâmico, sendo assim toda vez que a VM reiniciar este IP deverá ser novamente associado.

### Conectando à VM:

Nessas altura do campeonato o servidor já esta rodando e esperando você se conectar via SSH. Precisaremos mudar a permissão da chave privada, que deixaremos no home, e então usá-la com o IP que criamos:

```sh
# ajusta a permissao da key.
chmod 400 ~/mockr.pem
# conecta ao servidor.
ssh -i ~/mockr.pem ec2-user@177.71.181.76
```

Iremos confirmar (yes) a conexão e veremos possívelmente que há atualizações disponíveis:

```sh
The authenticity of host 'ec2-177-71-181-76.sa-east-1.compute.amazonaws.com (177.71-181-76)' can't be established.
RSA key fingerprint is 23:a1:de:08:42:fd:a1:08:ae:c4:23:f1:ed:0e:8f:42.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'ec2-177-71-181-76.sa-east-1.compute.amazonaws.com,ec2-177-71-181-76' (RSA) to the list of known hosts.

  __|  __|_  )
  _|  (  /  Amazon Linux AMI
  ___|___|___|

See /usr/share/doc/system-release/ for latest release notes.
There are 7 total update(s) available
Run "sudo yum update" to apply all updates.
```

### Atualizando a VM:

Para executar a atualização executaremos o seguinte comando confirmando (y) a ação:

```sh
# atualiza o sistema.
sudo yum update
```

<div style="color: #369; font: bold 16px arial; margin-bottom: 10px; margin-top: 25px;">Java 7</div>

Bem, essa imagem que escolhemos vem com a OpenJDK 1.6.0_22 Runtime Environment, porém queremos a JDK full. Para verificar e escolher entre as versões já disponíveis execute o comando:

```sh
# mostra as versoes disponiveis do java.
sudo update-alternatives --config java
```

**Subindo o pacote para o servidor:**

Acesse a página da [JDK7](http://www.oracle.com/technetwork/java/javase/downloads/java-se-jdk-7-download-432154.html), aceite o termo, localize a versão desejada e faça o download* para a sua máquina. Iremos utilizar aqui a versão no formato **.rpm**. Ao final do download devemos subir tal arquivo para o servidor com o comando:

```sh
# copia o pacote rpm para o servidor no home do nosso usuario (ec2-user)
scp -i ~/mockr.pem jdk-7-linux-i586.rpm ec2-user@ec2-177-71-181-76.sa-east-1.compute.amazonaws.com:/home/ec2-user
```

Finalizando o upload vamos nos conectar ao servidor e separar um lugar para mantermos as apps:

```sh
# conecta ao servidor.
ssh -i ~/mockr.pem ec2-user@177.71.181.76
# cria uma pasta para manter as apps.
mkdir ~/Development
# move a jdk para tal pasta.
mv ~/jdk-7-linux-i586.rpm ~/Development
```

### Instalando o pacote:

Agora vamos fazer a instalação com os seguintes comandos:

```sh
# recebe permissao root.
sudo su
# executa o pacote.
rpm -Uvh ~/Development/jdk-7-linux-i586.rpm
# java.
alternatives --install /usr/bin/java java /usr/java/latest/jre/bin/java 20000
# javaw.
alternatives --install /usr/bin/javaws javaws /usr/java/latest/jre/bin/javaws 20000
# javac.
alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 20000
alternatives --install /usr/bin/jar jar /usr/java/latest/bin/jar 20000
```

Pronto, confirme a versão executando:

```sh
# exibe a versao corrente do java.
java -version
```

```sh
java version "1.7.0"
Java(TM) SE Runtime Environment (build 1.7.0-b147)
Java HotSpot(TM) Client VM (build 21.0-b17, mixed mode, sharing)
```

### Configurando o Classpath

Para outras aplicações utilizarem o Java, se faz necessário a configuração do classpath. Existem arquivos no sistemas para esta finalidade como, por exemplo o **.bash_profile** que deverá ser editado:

```sh
# abre o arquivo para edicao.
vim ~/.bash_profile
```

Ao abrir o arquivo, apague o conteúdo exemplo contido nele apertando várias vezes a letra 'd' do teclado. Em seguida aperte a letra 'i' para mudar para o modo de inserção e cole o seguinte código:

```sh
# exporta a variavel JAVA_HOME com o caminho da JDK.
export JAVA_HOME="/usr/java/latest"

export PATH=$PATH:$JAVA_HOME/bin
```

Para salvar o arquivo aperte 'esc', digite ':x' e aperte 'enter'.
Este arquivo é lido toda vez que o nosso usuário é iniciado, logo precisamos forçar a leitura das novas configurações:

```sh
# faz a leitura do arquivo.
source ~/.bash_profile
```

<div style="color: #369; font: bold 16px arial; margin-bottom: 10px; margin-top: 25px;">Acertando a Key Pair</div>

Caso você já tenha avacalhado a sua chave de tanto trocá-la, receberá algo como:

```sh
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@  WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!  @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that the RSA host key has just been changed.
The fingerprint for the RSA key sent by the remote host is
85:8f:c7:e0:7f:84:f3:62:3d:82:33:7c:a9:92:3e:c7.
Please contact your system administrator.
Add correct host key in /Users/wbotelhos/.ssh/known_hosts to get rid of this message.
Offending key in /Users/wbotelhos/.ssh/known_hosts:8
RSA host key for 177.71.181.76 has changed and you have requested strict checking.
Host key verification failed.
lost connection
```

Neste caso veja que é indicado o problema na linha 8 do seu **~/.ssh/known_hosts**. Abra este arquivo e remova as referências para os IPs da Amazon que não existam mais, deixando apenas o seu atual (ex.: 177.71.181.76). Normalmente terá duas linhas uma iniciando em: "ec2-177-71-xxx-yy.sa-east-1..." e outra como: "177.71.xxx.yy ssh-rsa ...".

**E se eu quiser instalar o Java 6?**

Para instalar a [JDK6](http://jdk6.java.net/download.html) fazemos os mesmo passos, porém com outro pacote de instalação. Se você puxar uma versão "jdk-7-linux-i586-rpm**.bin**", por exemplo, não precisará executar o comando `rpm`, mas sim o arquivo diretamente: `./jdk-7-linux-i586-rpm.bin`.

<div style="color: #369; font: bold 16px arial; margin-bottom: 10px; margin-top: 25px;">* Formas de download dos arquivos</div>

De alguma forma a Amazon esta falhando em fazer download do pacote Java diretamente para o servidor, por isso fizemos o download para a nossa máquina e depois o subimos. Porém a forma mais fácil de fazê-lo é utilizando o `curl`:

```sh
curl http://www.java.net/download/jdk6/6u32/promoted/b03/binaries/jdk-6u32-ea-bin-b03-linux-amd64-29_feb_2012-rpm.bin > jdk6-rpm.bin
```

<div style="color: #369; font: bold 16px arial; margin-bottom: 10px; margin-top: 25px;">MySQL</div>

O MySQL é relativamente simples, basta executar os seguintes comandos:

```sh
# recebe permissao de root.
sudo su
# instala o pacote do mysql.
yum install mysql mysql-server mysql-libs
# inicia o servico.
service mysqld start
# configura a inicializacao.
chkconfig --levels 235 mysqld on
# inicia as configuracoes.
mysql_secure_installation
```

Durante o último comando serão pedidas algumas configurações:
+ Senha, apenas aperte enter;
+ Confirmação da ação (Y);
+ Uma nova senha e sua confirmação;
+ Remoção do usuário anônimo (Y);
+ Desabilitação de acesso remoto como root (Y);
+ Remoção da base de test (Y); e
+ Reload dos privilégios (Y).

**Trocando a senha de um usuário:**
Se você precisar trocar a senha do seu usuário, que digamos ser atualmente 'segredo', faça:

```sh
mysqladmin -u root -p'segredo' password 'novo_segredo';
```

**Criando o schema e um novo usuário:**

Precisamos de uma base de dados e por segurança um usuário com permissão somente sobre ela:

```sh
# acessa o console do mysql, a senha sera pedida.
mysql -u root -p
# cria um novo schema.
create schema mockr;
# cria um novo usuario (mockr) com permissao no schema (mockr) via web.
grant all on mockr.* to 'mockr'@'%' identified by 'segredo';
# da permissao para o usuario acessar via localhost.
grant all on mockr.* to 'mockr'@'localhost' identified by 'segredo';
```

Para verificar os schemas existentes, execute o comando:

```sh
show databases;
```

<div style="color: #369; font: bold 16px arial; margin-bottom: 10px; margin-top: 25px;">Tomcat 7</div>
Primeiramente pegue o link do pacote que você deseja no [site do Tomcat](http://tomcat.apache.org) e então execute:

```sh
# acessa a pasta das nossas apps.
cd ~/Development
# faz o download do tomcat.
curl http://apache.mirror.pop-sc.rnp.br/apache/tomcat/tomcat-7/v7.0.26/bin/apache-tomcat-7.0.26.tar.gz > apache-tomcat-7.0.26.tar.gz
# extrai o pacote do tomcat.
tar zxvf apache-tomcat-7.0.26.tar.gz
```

### Configurando o classpath

Agora vamos adicioná-lo no classpath editando o **~/.bash_profile**:

```sh
export JAVA_HOME="/usr/java/latest"
export TOMCAT_HOME=/home/ec2-user/Development/apache-tomcat-7.0.26

export PATH=$PATH:$JAVA_HOME/bin:$TOMCAT_HOME/bin
```

Execute o `source ~/.bash_profile` para reconhecimento das alterações e inicie o Tomcat. A seguir os comandos para manipulá-lo:

```sh
# inicia o tomcat.
$TOMCAT_HOME/bin/startup.sh
# para o tomcat.
$TOMCAT_HOME/bin/shutdown.sh
```

### Removendo arquivos desnecessários

```sh
# remove a pasta de documentos.
rm -rf $TOMCAT_HOME/webapps/docs
# remove a pasta com codigos de exemplo.
rm -rf $TOMCAT_HOME/webapps/examples
```

Agora basta acessar o seu IP na porta 8080 para ver o servidor rodando:

```sh
http://177.71.181.76:8080
```

> É, eu também dei um sorrisinho besta na primeira vez que subi meu server na Amazon. (;

### Configurando a inicialização do Tomcat

Vamos criar um arquivo de inicialização/manipulação do Tomcat para que o mesmo suba junto com a nossa VM. Execute o seguinte comando:

```sh
# prepara um novo arquivo.
sudoedit /etc/init.d/tomcat
```

E cole o código a seguir no mesmo:

```sh
#!/bin/sh
# Tomcat init script for Linux.
#
# chkconfig: 345 80 20
# description: Apache Tomcat

RETVAL="0"

case $1 in
start)
  echo "Starting Tomcat:"
  /home/ec2-user/Development/apache-tomcat-7.0.26/bin/startup.sh
  ;;
stop)
  echo "Stopping Tomcat:"
  /home/ec2-user/Development/apache-tomcat-7.0.26/bin/shutdown.sh
  ;;
restart)
  $0 stop
  $0 start
  ;;
*)
  echo "Usage: $0 {start|stop|restart}"
  RETVAL="1"
esac

exit $RETVAL
```

Modifique as permissões deste script e o insira nos serviços:

```sh
# tira a permissao de escrita do group e do other.
sudo chmod go-w /etc/init.d/tomcat
# adiciona o tomcat nos servicos de auto boot.
sudo chkconfig --add tomcat
```

Para verificar se o serviço "tomcat" foi incluido execute:

```sh
# mostra a lista dos servicos.
chkconfig --list
```

Agora você pode manipular o Tomcat como um serviço:

```sh
# para o servidor.
service tomcat stop
# inicia o servidor.
service tomcat start
# reinicia o servidor.
service tomcat restart
```

### Configurando a porta do Tomcat

Veja que o servidor esta na porta 8080, mas o legal seria tê-lo na porta 80, evitando indicar tal. Para isso iremos executar alguns comandos do iptables que mantém suas configurações em **/etc/sysconfig/iptables**:

```sh
# cria a roda da porta 80 para 8080.
sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
# salva a rota.
sudo service iptables save
# reinicia a tabela de rotas.
sudo service iptables restart
```

Por fim edite o arquivo **$TOMCAT_HOME/conf/server.xml** e adicione o atributo **proxyPort="80"** no seguinte ponto:

```xml
<Connector port="8080" protocol="HTTP/1.1"
  connectionTimeout="20000"
  redirectPort="8443"
  proxyPort="80" # adicao.
/>
```

Agora você pode acessar diretamente pelo IP (177.71.181.76), porém o que fazemos é configurar um domínio para o DNS público. Agora suba a sua aplicação e se divirta!

> Todo exemplo foi feito durante a configuração do [Mockr.me](http://mockr.me) que é um sistema focado em estudos para certificação e que estará disponível para acesso em breve.
