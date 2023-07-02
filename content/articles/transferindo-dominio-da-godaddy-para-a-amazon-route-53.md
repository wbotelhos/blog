---
date: 2015-03-30T00:00:00-03:00
description: "Transferindo Dominio da GoDaddy Para a Amazon Route 53"
tags: ["dominio", "godaddy", "amazon", "aws", "route53"]
title: "Transferindo Dominio da GoDaddy Para a Amazon Route 53"
---

Há um tempo atrás falei sobre [Configurando Domínio na Amazon Route 53 e GoDaddy](http://wbotelhos.com/configurando-dominio-na-amazon-route-53-e-godaddy), e hoje falarei sobre uma ótima notícia, de Julho de 2014, da Amazon. Eles agora registram domínios e não possuem a poluição visual e falta de usabilidade da [GoDaddy](godaddy.com). Entre as novidades apresentadas, a que mais gostei foi o `whois` privado e de graça, além do preço mais acessível.

# Objetivo

Transferir um domínio do GoDaddy para a Amazon Route 53.

# Desbloqueando a Transferência

Por medidas de segurança e para evitar uma transferência "burlada", os domínios já vêem bloqueados contra a ação de transferência, porém é simples desbloquear. Acesso o seu [Painel da GoDaddy](http://mya.godaddy.com) e expanda a seção *Domínios*, localize o domínio que deseja transferir e clique no botão *Administrar*.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/1.png" />

Na aba *Configurações* já aberta, na página apresentada, clique no link *Administrar* da seção *Bloquear*.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/2.png" />

Na pop up aberta, marque a opção *Desativar* e clique no botão salvar.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/3.png" />

# Requisitar Código de Autorização

É necessário um código de autorização para ser "entregue" para o futuro hospedador. Na mesma aba *Configurações*, clique no link *Enviar meu código por e-mail* da seção *Código de autorização*.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/4.png" />

Na pop up aberta, verifique se seu e-mail esta correto e clique no botão enviar *Enviar*.

> Atenção! Se você alterar seus dados relacionados ao domínio como, por exemplo, o e-mail, estará sujeito a esperar 60 dias para requisitar a transferência, de acordo com um [termo da ICANN](https://www.icann.org/resources/pages/policy-2012-03-07-en). Logo, tente evitar isso.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/5.png" />

# Requisitando a transferência

Você receberá um e-mail com o código de autorização.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/6.png" />

Copie esse código e acesse o [https://console.aws.amazon.com/route53/home?#DomainTransfer:](https://console.aws.amazon.com/route53/home?#DomainTransfer:) na página de transferência de domínio e faça o seguinte:

- Digite o nome do dom ser transferido;
- Click no botão *Check*;
- Click no botão Add to Cart; e
- Click no botão *Continue*.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/7.png" />

Se você já tiver usando um DNS que se permanecerá, poderá deixar escolhido a primeira opção "Continue to use the name servers provided by the current registrar or DNS service", mas sugiro você aproveitar o serviço da Route 53 e configurar seu DNS, como descrito no artigo [Configurando Domínio na Amazon Route 53 e GoDaddy](http://wbotelhos.com/configurando-dominio-na-amazon-route-53-e-godaddy). Assim selecionaríamos a segunda opção e já entraríamos com os devidos valores de DNS clicando no botão *Continue*.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/8.png" />

Agora iremos preencher nossos dados pessoais e usufruir de uma das vantagens do Route 53: Proteção de informações no `whois`, ou seja, nosso número de telefone e e-mail serão ocultados. Este serviço normalmente é pago, mas aqui podemos escolhê-lo gratuitamente. Então deixe marcado a primeira opção e clique no botão *Continue*.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/9.png" />

Aceite o termo e o leia, se for capaz, e clique no botão *Complete Purchase*.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/10.png" />

Agora é só aguardar que a aprovação de transferência, mas fique atento! Você receberá um e-mail com um link de confirmação. Se você não clicar neste link dentro de 6 dias, a tranferência será cancelada.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/11.png" />

Agora basta autorizar a transferência clicando no botão *validate*.

<img class="align-center" title="Iniciar edição" src="https://s3-sa-east-1.amazonaws.com/blogy/transferindo-dominio-da-godaddy-para-a-amazon-route-53/12.png" />

Acompanhe o status do seu pedido em [https://console.aws.amazon.com/route53/home?#DomainRequests:](https://console.aws.amazon.com/route53/home?#DomainRequests:)
