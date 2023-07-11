---
date: 2015-04-05T00:00:00-03:00
description: "Criando Chave SSH Para Acesso ao Github"
tags: ["github", "ssh"]
title: "Criando Chave SSH Para Acesso ao Github"
---

A chave SSH é uma forma facilitada de conseguir acesso em um servidor/serviço, onde você não precisará digitar a senha, mas sim apresentar a chave. Trabalhamos com dois tipos de chaves, a Pública, nosso cartão de visita, que deixamos nos serviços/servidores onde queremos acesso e a Privada, nossa identidade, na qual guardamos com a gente para provarmos que somos quem o "cartão de visita" diz nós sermos.

# Objetivo

Criar uma chave SSH para ser possível clonar um projeto do [Github](https://github.com).

# Criptografia

Por padrão as [chaves RSA](http://pt.wikipedia.org/wiki/RSA) são criadas com criptografia de 2048 bits, logo iremos utilizar uma criptografia mais segura de 4096. Por padrão o nome da chave será `id_rsa`, porém podemos trocar esse nome usando a opção `-f` para indicar o caminho do arquivo. Além disso podemos adicionar um comentário que será adicionado no final da chave, utilizando a opção `-C`:

```sh
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C jenkins@blog.com
```

Então será gerada a chave privada `~/.ssh/id_rsa` e a pública `~/.ssh/id_rsa.pub`.

# Permissões

As chaves, assim como o diretório `~/.ssh` devem estar com as devidas permissões configuradas:

```sh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
```

# SSH Agent

O [SSH Agent](http://en.wikipedia.org/wiki/Ssh-agent) é um programa encarregado de guardas as nossas chaves privadas. Se ele não obtiver a chave consigo, mesmo que ela tenha sido gerada e esteja no diretório `~/.ssh`, poderá não ser reconhecida. Para verificar as chaves carregadas execute:

```sh
ssh-add -l # -L também mostra o conteúdo.
```

Se a chave que criamos não estiver carregada, teremos que adicioná-la:

```sh
ssh-add ~/.ssh/id_rsa # o comando `ssh-add` por padrão adiciona `id_rsa`.
```

## Problemas

`Could not open a connection to your authentication agent.`

Neste caso é necessário iniciar o agente:

```sh
eval `ssh-agent`
```

Se preferir, adicione esse comando ao seu `~/.bashrc` ou `~/.bash_profile` para que o mesmo sempre seja inicializado.

# Chave Pública (Cartão de Visita)

Agora precisamos de deixar a chave pública no serviço que desejamos acesso, no caso o [http://github.com](https://github.com). Copie o conteúdo da chave pública:

```sh
cat ~/.ssh/id_rsa.pub
```

Acesse o seu projeto e vá no menu *Settings*:

<img class="align-center" title="Criando Chave SSH Para Acesso ao Github" src="https://s3-sa-east-1.amazonaws.com/blogy/criando-chave-ssh-para-acesso-ao-github/criando-chave-ssh-para-acesso-ao-github-01.png" />

Então acesse o menu *Deploy keys*, clique no botão *Add deploy key*, escreva um título para a chave no campo *Title*, cole o conteúdo da chave no campo *Key* e clique em *Add key*.

<img class="align-center" title="Criando Chave SSH Para Acesso ao Github" src="https://s3-sa-east-1.amazonaws.com/blogy/criando-chave-ssh-para-acesso-ao-github/criando-chave-ssh-para-acesso-ao-github-02.png" />

# Testando

Vá na máquina onde se encontra a chave privada e execute o comando:


```sh
git ls-remote git@github.com:wbotelhos/blog
```

Se tudo estiver correto, serão listadas os SHA das suas branchs:

```sh
cf0f5e487df1c8acaf21f58c5fdbfa0826f5f950	 HEAD
cf0f5e487df1c8acaf21f58c5fdbfa0826f5f950	 refs/heads/master
```

> Tente sempre identificar suas chaves como **aplicacao@dominio**, e usar a mesma identificação nos serviços onde serão salvas. No caso `jenkins@blog.com` me diz que essa chave é usada pelo Jenkins no servidor **blog.com**.

Aqui tem uns scripts para lhe ajudar nessas tarefas: [http://github.com/wbotelhos/installers/tree/master/ssh_key](https://github.com/wbotelhos/installers/tree/master/ssh_key)
