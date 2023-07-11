---
date: 2015-04-07T00:00:00-03:00
description: "Acertando o Warning de Decode do Jenkins"
tags: ["jenkins", "warning"]
title: "Acertando o Warning de Decode do Jenkins"
---

No artigo passado, [Instalando o Jenkins no Tomcat](http://wbotelhos.com/instalando-o-jenkins-no-tomcat), foi mostrado como instalar o Jenkins. Porém ao acessar o *Manage Jenkins* nos deparamos com a seguinte mensagem: **Your container doesn't use UTF-8 to decode URLs. If you use a non-ASCII characters as a job name etc, this will cause problems. See Containers and Tomcat i18n for more details.**.

# Objetivo

Configurar o container para usar UTF-8 como decode.
Instalando o Jenkins
# Problema

<img class="align-center" title="Acertando o Warning de Decode do Jenkins" src="https://s3-sa-east-1.amazonaws.com/blogy/acertando-o-warning-de-decode-do-jenkins/acertando-o-warning-de-decode-do-jenkins-01.png" />

Essa mensagem de alerta, vem do container que estamos usando, o [Tomcat](http://tomcat.apache.org), que diz não estarmos usando [UTF-8](http://pt.wikipedia.org/wiki/UTF-8) para decodificação e então poderemos ter problemas ao lidarmos com palavras que contenham acentos.

# Solução

Para resolver isso, basta dizer para o Tomcat usar UTF-8. edite o arquivo `server.xml` que se encontra no home do Tomcat. No meu caso:

```sh
sudo vim /var/lib/tomcat/conf/server.xml
```

Procure pelo bloco `Connector` da porta `8080`:

```sh
 <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443"
/>
```

E adicione a propriedade `URIEncoding="UTF-8"`:

```sh
 <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443"
               URIEncoding="UTF-8"
/>
```

Agora basta reiniciar o Tomcat e o alerta irá sumir.

Apesar de corrigido, não é uma boa prática utilizar nome de jobs com acento nem com letras maiúscula, visto que o nome fará parte parte do URL.

> Esse problema não ocorre mais no Tomcat 8.
