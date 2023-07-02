---
date: 2015-04-09T00:00:00-03:00
description: "Protegendo o Jenkins Com Senha"
tags: ["jenkins", "senha"]
title: "Protegendo o Jenkins Com Senha"
---

Nos artigos passado, instalamos o Jenkins [Instalando o Jenkins no Tomcat](http://wbotelhos.com/instalando-o-jenkins-no-tomcat) e configuramos o Decode [Acertando o Warning de Decode do Jenkins](http://www.wbotelhos.com/acertando-o-warning-de-decode-do-jenkins), porém ainda temos o problema do Jenkins estar aberto e acessível para o mundo, onde basta o usuário saber a URL de acesso para manipular completamente sua CI.

# Objetivo

Proteger o Jenkins com senha de autenticação para acesso.

# Problema

Ao acessarmos o *Manage Jenkins*, iremos ver um alerta dizendo que estamos desprotegidos:

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-01.png" />

Isso significa que qualquer pessoa que souber o endereço do Jenkins, poderá manipulá-lo.

# Solução

Precisamos de criar um passo de autenticação. Para isso precisamos, primeiro, habilitar a criação/login de usuários acessando *Manage Jenkins* e em seginda *Configure Global Security*:

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-02.png" />

Marque a opção *Enable Security* e então a opção *Jenkins' own user database*. Isso irá disponibilizar a opção, já marcada, *Allow users to sign up*.

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-03.png" />

Salve as configuração clicando no botão *Save* e após o refresh da tela, já estará disponível a criação e login de usuário no canto superior direito da tela:

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-04.png" />

Acesse esse link, preencha os dados e clique no botão *Sign up* para criar o usuário:

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-05.png" />

Agora que temos um usuário, podemos voltar para a tela de [configuração de segurança](http://localhost:8080/jenkins/configureSecurity) e dar as devidas permissões para este usuário (jenkins). Vamos marcar a opção *Matrix-based security* digitar o nome do nosso usuário no campo *User/group to add* e clicar no botão *Add* para adicioná-lo. Com ele na grade, vamos dar todos as permissões, marcando todos as opção da linha:

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-06.png" />

> O layout dá scroll horizontal, porém há um botão "marcar tudo" no final da tela que pode ser usado.

Basta salvar e já será pedido usuário e senha, sendo que não terá mais a opção *sign up*, pois agora somente usuários logados e com permissão podem criar outros usuários:

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-07.png" />

Faça o login e para uma maior segurança, vamos remover o usuário *Anonymous* acessando o URL [http://localhost:8080/jenkins/user/anonymous/delete](http://localhost:8080/jenkins/user/anonymous/delete) e confirmando a exclusão clicando no botão *Yes*.

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-08.png" />

Você poderá ver os usuários cadastrados no menu *People*:

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-09.png" />


Para criar ou editar usuários, basta acessar *Manage Jenkins* e então acessar *Manage Users*:

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-10.png" />

Então você poderá criar um usuário novo ou editar os existes. Já o seu próprio usuário, sempre estará disponível no menu localizado no canto superior direito da tela.

<img class="align-center" title="Protegendo o Jenkins Com Senha" src="https://s3-sa-east-1.amazonaws.com/blogy/protegendo-o-jenkins-com-senha/protegendo-o-jenkins-com-senha-11.png" />
