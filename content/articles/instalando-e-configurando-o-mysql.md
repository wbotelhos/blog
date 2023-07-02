---
date: 2012-10-17T00:00:00-03:00
description: "Instalando e Configurando o MySQL"
tags: ["mysql"]
title: "Instalando e Configurando o MySQL"
---

O [MySQL](https://www.mysql.com) é um banco de dados vastamente utilizado e com diversos comandos. Se você constantemente precisa instalar e configurá-lo, acompanhe.

### Objetivo

Instalar e configurar o MySQL, assim como manipular alguns de seus comandos.

### Linux

Sem dúvidas no [Linux](http://en.wikipedia.org/wiki/Linux) o [apt-get](http://en.wikipedia.org/wiki/Advanced_Packaging_Tool) deixa tudo mais fácil, bastanto executar:

```bash
sudo apt-get install mysql-client mysql-server libmysqlclient-dev
```

### Red Hat

A distribuição da [Red Hat](http://en.wikipedia.org/wiki/Red_Hat) é manipulada via [yum](http://en.wikipedia.org/wiki/Yellowdog_Updater,_Modified):

```bash
sudo yum install mysql mysql-server mysql-libs
```

### Mac

No [MacOSX](http://pt.wikipedia.org/wiki/OS_X) também temos um facilitador de instações, chamado [Homebrew](http://brew.sh). Basta instalá-lo de acordo com o site e então executar:

```bash
brew install mysql
```

### Configurações

Independente da distribuição, para configurar o MySQL utilizamos os mesmos passos:

```bash
mysql_secure_installation
```

Ao executar o comando acima serão pedidas algumas configurações:

+ Senha, apenas aperte enter;
+ Confirmação da ação (Y);
+ Uma nova senha e sua confirmação;
+ Remoção do usuário anônimo (Y);
+ Desabilitação de acesso remoto como root (Y);
+ Remoção da base de test (Y); e
+ Reload dos privilégios (Y).

### Senha

Se você precisar trocar a senha do seu usuário, que digamos ser atualmente 'secret', poderá utilizar o **mysqladmin**:

```mysql
mysqladmin -u root -p'secret' password 'new_secret';
```

Repare que a senha atual já é passada *inline* e junto com o parâmetro `-p`, não é um erro. Em seguida dizemos qual será a nova senha. Cuidado com os [Stalkers](http://en.wikipedia.org/wiki/Stalking)!

### Acesso

O console do MySQL é acessado passando o usuário e senha:

```mysql
mysql -u root -p

# password:
```

### Schema

Para criar um schema acesse o console e digite:

```mysql
create schema my_schema;
```

Caso queira verificar os já criados:

```mysql
show databases;
```

E para se conectar a um schema para manipular as tabelas execute:

```mysql
use my_schema;
```

No console do MySQL os comandos terminam com ponto-e-vígula, se você esquecê-lo, será pedido na próxima linha após o enter.

### Usuário

#### Criação + Permissões

Podemos criar nossos usuários com devidas permissões para cada tabela específica em algum schema:

```mysql
grant all on my_schema.* to 'my_user'@'%' identified by 'secret';
```

Um usuário **my_user** foi criado com permissão no schema **my_schema** para acesso via web **%**. Com isso podemos acessar a base de dados sem estar no localhost do servidor.

Mas podemos e devemos dar acesso a este usuário via **localhost**, pois esta é a forma mais comum, já que logamos no servidor e então damos as devidas manutenções:

```mysql
grant all on my_schema.* to 'my_user'@'localhost' identified by 'secret';
```

Quando dizemos `my_schema.*` com um asterísco, estamos especificando a permissão para todas as tabelas, mas poderíamos muito bem especificar qual tabela queremos dar o acesso:

```mysql
grant all on my_schema.table_name to 'my_user'@'localhost' identified by 'secret';
```

#### Criação + Sem senha

Se precisar criar um usuário sem senha, omita alguns comandos:

```mysql
create user 'test'@'localhost';
```

#### Listagem

```mysql
select host, user, password from mysql.user;
```

#### Remoção

```mysql
drop user user_name;
```


### Tabelas

Teremos várias tabelas na base de dados, para listá-las, conecte ao schema e execute:

```mysql
show tables;
```

E então podemos executar nosso `SELECT`, `INSERT`, `UPDATE`, `DELETE` etc.

### Backup

Algo bem normal de fazermos em nosso servidor é a ação de backup que não passa de uma linha de comando:

```bash
mysqldump -u root -p'my_password' my_schema > my_dump.sql
```

### Restore

O restore é bem simples também:

```bash
mysql -u root -p'my_password' my_schema < my_dump.sql
```

> Nossa mudou só a direção da setinha rs... #lol
