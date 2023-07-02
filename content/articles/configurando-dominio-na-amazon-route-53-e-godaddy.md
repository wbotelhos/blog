---
date: 2012-01-26T00:00:00-03:00
description: "Configurando Domínio na Amazon Route 53 e GoDaddy"
tags: ["godaddy", "amazon", "aws", "route53"]
title: "Configurando Domínio na Amazon Route 53 e GoDaddy"
url: "configurando-dominio-na-amazon-route-53-e-godaddy"
---

Quando criamos um servidor e subimos nossa aplicação neste, obtemos um endereço de [DNS](http://pt.wikipedia.org/wiki/Domain_Name_System) como mostrado no artigo [Ruby Unicorn e NGINX na Amazon EC2](http://wbotelhos.com/ruby-unicorn-e-nginx-na-amazon-ec2). Porém queremos mais do que este nome grande e ruim de memorizar, queremos um nome de domínio fácil do usuário assimilar.

## Objetivo

Criar um domínio no [GoDaddy.com](GoDaddy.com) e configurá-lo utilizando o serviço Route 53 da Amazon.

## Elastic IP

Como primeiro passo, devemos tomar posse de um IP para trabalharmos em vez do DNS. Para isso acesse o [EC2 Management Console](https://console.aws.amazon.com/ec2/v2) e na seção *NETWORK & SECURITY* click na opção *Elastic IP*

Click no botão *Allocate New Address* e será aberto uma janela modal. Selecione a opção **EC2** e click no botão *Yes, Allocate*. Agora você tem um IP reservado, porém ele não esta vinculado a nenhuma instância sua, logo devemos selecioná-lo dentre a listagem, clicar no botão *Associate Address* e selecionar a instância que queremos vinculá-la.

> Perceba como é importante você dar um nome (label) para as suas instâncias, pois assim ela será identificada facilmente, caso contrário será apenas número como, por exemplo, **i-db3ed8c5** - (aqui seria o label)

Bem, já temos um IP e você já pode acessar sua aplicação através dele. Anote-o!

> Cuidado, pois cada IP alocado e não associado será cobrado. Para remover um IP, basta clicar no botão *Release Address*.

## Route 53

Com o nosso IP em mãos vamos configurar o [Route 53](https://console.aws.amazon.com/route53/home).

Clique no botão *Create Hosted Zone* para aparecer um painel na lateral direita, onde iremos digitar o nome do nosso domínio, algo como **wbotelhos.com**. O campo *comment* é opcional. Então clique no botão *Create Hosted Zone* logo abaixo.

Na listagem central selecione o domínio que acabou de criar e copie os endereços listados na seção *Delegations Set* listada no quadro lateral direito, algo como:

```
ns-1395.awsdns-46.org
ns-946.awsdns-54.net
ns-1750.awsdns-26.co.uk
ns-26.awsdns-03.com
```

### Truque da latência

Esses endereços são servidores de DNS, e são vários para podermos usá-los de backup caso um ou outro falhe. Por isso é importante sempre organizá-los na ordem crescente de latência. Para isso abra o console e *ping* cada um deles em uma aba e compare as latências, dai basta anotá-los:

```
ping ns-1395.awsdns-46.org
ping ns-946.awsdns-54.net
ping ns-1750.awsdns-26.co.uk
ping ns-26.awsdns-03.com
```

No meu caso obtive a seguinte ordem, anote!:

```
ns-1395.awsdns-46.org
ns-1750.awsdns-26.co.uk
ns-946.awsdns-54.net
ns-26.awsdns-03.com
```

Com o seu domínio ainda selecionado, clique no botão *Go to Record Sets* e uma outra tela mostrará algumas configurações a respeito do seu domínio. Click no botão *Create Record Set* e aparecerá o painel direito de configuração.

### Operação por subdomínio

1. No campo **Name** digite **www**, ou seja, estaremos configurando o domínio **www**.wbotelhos.com, por exemplo;
2. Na opção **TTL (Seconds)** clique no botão **1h** para configurar o tempo de expiração do DNS do nosso domínio em 1 hora;
3. No campo **Value** digite o **Elastic IP** criado há pouco.

Repita a operação acima trocando o valor do item *1* para * (asterisco).
E mais uma vez com o valor "" (vazio).

Assim teremos wbotelhos.com, *.wbotelhos.com e www.wbotelhos.com apontando para o mesmo IP.

## Go Daddy

Agora basta dizermos para o [Go Daddy](http://godaddy.com) apontar para os nossos servidores de DNS. Faça o login e acesse a sua conta [https://mya.godaddy.com](https://mya.godaddy.com).

Expanda o item *Domínios* e clique no botão **Iniciar** da coluna **Ação**. Na seção **Servidores de nomes** clique no link *Administrar* e na janela aberta, selecione a opção **Personalizar*.

Agora iremos entrar com os nossos DNSs copiados em ordem crescente de latência, para isso basta clicar no botão **Adicionar servidor de nomes.**. Entre com os dois primeiros DNSs e clique no botão **Adicionar servidor de nomes.** para adicionar outros dois campos restantes clicando em **OK** em seguida. Os endereços serão validados só restando clicar no botão **Salvar** para concluir e aguarde alguns instantes até as configurações serem aplicadas.

> É, agora que o GoDaddy esta com escritório no Brasil o site vem em português, que eu particulamente acho ruim, por isso as instruções de tela foram ditas e português.

Bem, é isso! Basta aguardar o DNS ser replicado e parabéns pelo seu novo site! :)
