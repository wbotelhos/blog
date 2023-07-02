---
date: 2012-09-04T00:00:00-03:00
description: "Instalando o Ruby, Rails e RVM no Mac"
tags: ["ruby", "rvm", "mac"]
title: "Instalando o Ruby, Rails e RVM no Mac"
---

<img class="align-center" title="Ruby" src="http://www.ruby-lang.org/images/logo.gif" alt="Ruby" width="331" height="119" />

Com o passar do tempo algumas linguagens de desenvolvimento vão surgindo e outras sendo mais popularizadas como é o caso do [Ruby](http://www.ruby-lang.org), que vem tomando grande porção do mercado de software. Essa "linguagem de script" com sua tipagem dinâmica conquista cada dia mais os desenvolvedores.

### Objetivo

Instalar o Ruby, Rails e o RVM no Mac deixando o ambiente pronto para codar.

### RVM

O [RVM](http://rvm.beginrescueend.com) (Ruby Versions Manager) é um gerenciador de versões do Ruby e além de gerenciar tais, também é capaz de criar *gemsets*, que é um conjuto de libs separadas em um contexto, geralmente para um projeto específico. Para instalá-lo basta executar:

``` text
curl -L get.rvm.io | bash -s stable
```

Para verificar se a instalação ocorreu com sucesso execute:

``` text
type rvm | head -1
```

Para garantir que esta com a última versão do RVM, rode periódicamente, inclusive agora, o comando:

``` text
rvm get latest
```

Durante a instalação é adicionado no final do seu *~/.bash_profile* um comando que carrega o RVM, que poderá ser:

``` text
source ~/.rvm/scripts/rvm
```

Após colar o comando acima, recarregue o bash profile:

``` text
source ~/.bash_profile
```

### Compilador

Para rodar o Ruby precisamos do compilador C que vem no [Xcode](https://developer.apple.com/xcode), porém se você não for desenvolver para IOS é uma boa pegar apenas o [GCC](https://github.com/kennethreitz/osx-gcc-installer/downloads) e economizar vários **kibes**. Este GCC esta [deprecated](http://kennethreitz.com/xcode-gcc-and-homebrew.html), porém ainda não consegui fazer funcionar com o [Command Line Tools](https://developer.apple.com/downloads) desponibilizado pela Apple.

### Ruby

Para instalar o Ruby é muito simples, iremos fazer isso à partir do RVM e garantir que a versão instalada será a default:

``` text
rvm install 1.9.3
rvm use 1.9.3 --default
ruby -v
```

### Rails

Para instalar o Rails é muito simples:

``` text
gem install rails
rails -v
```

Para testar se esta tudo certo crie um projeto em algum lugar de sua preferência:

``` text
rails new test
```

Então acesse o projeto e inicie o servidor:

``` text
cd test
rails s
```

Agora basta acessar a sua aplicação no endereço `http://localhost:3000`

``` text
Welcome aboard
You’re riding Ruby on Rails!
```
