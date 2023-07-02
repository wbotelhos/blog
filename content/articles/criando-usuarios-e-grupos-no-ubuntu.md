---
date: 2015-04-13T00:00:00-03:00
description: "Criando Usuários e Grupos no Ubuntu"
tags: ["ubuntu", "grupos", "usuarios"]
title: "Criando Usuários e Grupos no Ubuntu"
url: "criando-usuarios-e-grupos-no-ubuntu"
---

Muita gente nunca criou um usuário em seu SO, estes por sua vez ao rodarem aplicações como o Nginx, acabou por rodá-las com o usuário *Root*. Essa prática é perigosa, pois se alguém tomar poder da aplicação, estará com acesso a este usuário, que tudo pode fazer no SO. Por isso irei mostrar como é simples criar um usuário e manipular grupos.

# Objetivo

Criar um usuário em um determinado grupo

# Usuário

Como listar:

```bash
cat /etc/passwd
```

Como criar:

```bash
sudo adduser tomcat # também cria um grupo com o mesmo nome.
```

Como apagar:

```bash
sudo deluser tomcat --remove-home
```

# Grupo

Como listar:

```bash
cat /etc/group
```

Como criar:

```bash
sudo addgroup jenkins
```

Como apagar:

```bash
sudo delgroup jenkins
```

# Usuário (existente) x Grupo (existente)

```bash
sudo usermod -append --groups jenkins tomcat
```

# Usuário (novo) x Grupo (existente)

```bash
sudo adduser --ingroup jenkins tomcat
```

# Home

Se por algum motivo você tenha um usuário sem o home, é possíve recriá-lo:

```bash
/sbin/mkhomedir_helper tomcat
```
