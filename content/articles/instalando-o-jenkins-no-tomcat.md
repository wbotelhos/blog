---
date: 2015-04-06T00:00:00-03:00
description: "Instalando o Jenkins no Tomcat"
tags: ["jenkins", "java", "tomcat"]
title: "Instalando o Jenkins no Tomcat"
---

[Integração Contínua](http://en.wikipedia.org/wiki/Continuous_integration) (CI) é algo muito falado nos dias atuais. De forma simples, CI é uma forma de obter feedback rápido e agilizar a entrega do produto. Depois de algumas evoluções do CI, surgiu o [Hudson](http://hudson-ci.org) que a comunidade forkou e criou o [Jenkins](https://jenkins-ci.org), já que a [Oracle](www.oracle.com) teve interesse em patentiar o nome e doou para a [Eclipse Foundation](https://eclipse.org/org/foundation). Mas cá entre nós: confiamos mais na comunidade. <3

# Objetivo

Instalar o Jenkins usando o Tomcat como container.

# Dependencias

## Java

Primeiramente, precisamos de ter o [Java](https://www.java.com) instalado na máquina. Você pode fazer isso do seu jeito ou utilizar o seguinte script para isso: [https://github.com/wbotelhos/installers/blob/master/java](https://github.com/wbotelhos/installers/blob/master/java/install.sh)

## Tomcat

O [Tomcat](http://tomcat.apache.org) será o container responsável por rodar o Jenkins. Aqui também tem um script para agilizar a instalação: [http://github.com/wbotelhos/installers/tree/master/tomcat](https://github.com/wbotelhos/installers/tree/master/tomcat)

# Jenkins

O Jenkins, nada mais é do que um aplicação empacotado em um arquivo de distribuição Java, chamado `jenkins.war`. Que pode ser baixado no [site](http://mirrors.jenkins-ci.org/war/latest/jenkins.war) e copiado para o diretório `webapps` do Tomcat, no nosso caso, localizado em `/var/lib/tomcat` ou no local que você escolheu deixar.

Após copiar o arquivo `.war`, basta iniciar o Tomcat para ele "explodir" o `jenkins.war` e criar uma pasta de mesmo nome, `jenkins`:

```sh
sudo service tomcat start
```

Aguarde um instante e poderá acessar o Jenkins na url: `http://localhost:8080/jenkins`

<img class="align-center" title="Instalando o Jenkins no Tomcat" src="https://s3-sa-east-1.amazonaws.com/blogy/instalando-o-jenkins-no-tomcat/instalando-o-jenkins-no-tomcat-01.png" />

# Context

O Tomcat irá usar o nome da pasta do Jenkins como parta do URL de acesso de seu admin, assim temos o acesso `http://localhost:8080/jenkins`, pois o arquivo `jenkins.war` gerou a pasta `jenkins`. Você pode mudar esse nome para o que desejar, ou se o seu Tomcat é exclusivo para rodar o Jenkins, renomeio o `jenkins.war` para `ROOT.war`, em maiúsculas, para o Jenkins ficar na raiz: `http://localhost:8080`.

Para facilitar todo esse tramite, você pode usar esse script: [https://github.com/wbotelhos/installers/blob/master/jenkins/install.sh](https://github.com/wbotelhos/installers/blob/master/jenkins/install.sh)
