---
date: 2015-04-08T00:00:00-03:00
description: "Ajustando o Timezone do Ubuntu"
tags: ["ubuntu", "timezone"]
title: "Ajustando o Timezone do Ubuntu"
---

Se eu pudesse dizer duas coisas que dão dor de cabeça seriam: Encode e [Timezone](http://en.wikipedia.org/wiki/Time_zone). Se os seus teste de envolvem data e hora passam na sua máquina, mas quebram no servidor, estou pra te dizer que você, no mínimo, concorda com 50% do que eu disse.

# Objetivo

Alterar o Timezone do Ubuntu para um específico

# Timezone Atual

Você pode verificar o seu timezone atual:

```bash
cat /etc/timezone
# America/New_York
```

Se no seu caso, igual o meu, você mora no Brasil (São Paulo), então você precisa de ajustá-lo.

# Opções

Você pode listar os grupos de timezone:

```bash
ls /usr/share/zoneinfo
```

São Paulo estará dentro de **America**, mesmo que intuitivamente pensemos estar em **Brazil**. Então liste os items:

```bash
ls /usr/share/zoneinfo/America
```

Você verá que existe a opção `Sao_Paulo`. Então bastaria alterar o conteúdo do arquivo `/etc/timezone` para `America/Sao_Paulo`, porém iremos fazer um link simbólico:

```bash
sudo rm /etc/timezone
sudo ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/timezone
```

Para aplicar a nova configuração, execute:

```bash
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Current default time zone: 'America/Sao_Paulo'
# Local time is now:      Tue Apr  7 11:39:20 BRT 2015.
# Universal Time is now:  Tue Apr  7 14:39:20 UTC 2015.
```
