---
date: 2012-04-18T00:00:00-03:00
description: "Instalando o MongoDB no Mac OS X"
tags: ["mongodb", "mac", "osx"]
title: "Instalando o MongoDB no Mac OS X"
---

No mundo dos banco de dados, o [MongoDB](https://www.mongodb.org) se destaca entre os bancos do tipo [NoSQL](http://en.wikipedia.org/wiki/NoSQL). Escrito em [C++](http://en.wikipedia.org/wiki/C++), o Mongo é um banco [orientado a documento](http://en.wikipedia.org/wiki/Document-oriented_database), onde podemos trabalhar com uma estrutura dinâmica e manipular dados [JSON](http://en.wikipedia.org/wiki/JSON).

# Objetivo

Instalar e configurar o MongoDB no sistema operacional Mac OS X.

# Download

```bash
mkdir ~/Development
cd ~/Development
curl -O http://downloads.mongodb.org/osx/mongodb-osx-x86_64-2.6.0.tgz
tar zxf mongodb-osx-x86_64-2.6.0.tgz
mv mongodb-osx-x86_64-2.6.0 mongodb
```

# Local

Eu pessoalmente gosto de deixar todos os meus programas na pasta `~/Development`, assim posso fazer backup deles sem me esquecer de nada. Porém para não termos que sempre especificar o nome de usuário, pois estará na sua home, vamos criar um link simbólico no `/usr/local`, lugar comum para se deixar programas do usuário:

```bash
sudo ln -s ~/Development/mongodb /usr/local/mongodb
```

# Data Store

Por padrão o Mongo armazena os dados no diretório `/data/db`:

```bash
sudo mkdir -p /data/db
```

Para evitar o seguinte erro no futuro:

```bash
Unable to create/open lock file: /data/db/mongod.lock
```

Vamos atribuir o usuário corrente (`whoami`) como dono dessa pasta:

```bash
sudo chown -R `whoami` /data
```

# Configurando o Classpath

Dentro do diretório `/usr/local/mongodb/bin` há vários comandos nos quais podemos executar:

```bash
bsondump
mongo
mongod
mongodump
mongoexport
mongofiles
mongoimport
mongooplog
mongoperf
mongorestore
mongos
mongosniff
mongostat
mongotop
```

Para ser possível executar esses comando sem passar seu caminho completo, precisamos editar o arquivo `.bash_profile`:

```bash
vim ~/.bash_profile
```

E adicionar o caminho da pasta `bin` no `$PATH` do sistema:

```bash
export MONGODB_HOME=/usr/local/mongodb
export PATH=${PATH}:${MONGODB_HOME}/bin
```

Se já existir um *export* do `PATH`, basta adicionar o *path* do Mongo usando o `:` (dois pontos). Algo como: `export PATH=${PATH}:${OTHER_HOME}/bin:${MONGODB_HOME}/bin`.

Recarregue o arquivo:

```bash
source ~/.bash_profile
```

Agora podemos executar todos os comandos facilmente:

```bash
mongo -version
# MongoDB shell version: 2.6.0
```

# Auto Start

Podemos inicializar o Mongo, basta digitar `mongod`, de preferência com um `&` no final para evitarmos que ele morra se fecharmos a aba do terminal. Só que isso não o mantém rodando ao reiniciar a máquina. Podemos configurar sua inicialização automática criando um **launchd job**:

```bash
sudo vim /Library/LaunchDaemons/mongodb.plist
```

Com o seguinte conteúdo:

```bash
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
<dict>
  <key>Label</key>
  <string>org.mongodb.mongod</string>

  <key>RunAtLoad</key>
  <true />

  <key>KeepAlive</key>
  <true />

  <key>WorkingDirectory</key>
  <string>/usr/local/mongodb</string>

  <key>ProgramArguments</key>
  <array>
    <string>/usr/local/mongodb/bin/mongod</string>
    <string>run</string>
    <string>--config</string>
    <string>/usr/local/mongodb/mongod.yml</string>
  </array>
</dict>
</plist>
```

Repare que em uma linha indicamos que teremos uma *key* e logo em seguida dizemos qual o valor pra tal *key*. Obtendo algo como `RunAtLoad=true`. No caso do `ProgramArguments` passamos um *array* de comandos, sendo que a some deles separados por espaço, formará nosso comando final:

```bash
/usr/local/mongodb/bin/mongod run --config /usr/local/mongodb/mongod.yml
```

O interessante da inicialização é que podemos passar um arquivo de configuração contendo alguns comandos desejados. Vamos criar esse arquivo:

```bash
vim /usr/local/mongodb/mongod.yml
```

Com o conteúdo:

```bash
processManagement:
  pidFilePath: '/var/run/mongodb.pid'

systemLog:
  destination: 'file'
  logAppend: true
  path: '/var/log/mongodb/out.log'
  quiet: false
```

Acesse [http://docs.mongodb.org/manual/reference/configuration-options](http://docs.mongodb.org/manual/reference/configuration-options) para saber as possíveis configurações.

Agora vamos carregar o nosso job manualmente:

```bash
sudo launchctl load /Library/LaunchDaemons/mongodb.plist
```

Pronto, esta tudo configurado. Você já pode acessar seu banco:

```bash
mongo
```

Para listar os *schemas* existentes:

```bash
show dbs
# wbotelhos_development
```

Usar um *schema*:

```bash
use wbotelhos_development
```

Para mostrar as *collections* do *schema*:

```bash
show collections
```

> Ou mais simples: `show tables`

Para ver os dados de uma *collection*:

```bash
db.articles.find().pretty()
```

> O `.pretty()` não é obrigatório, mas é legal para trazer o JSON indentado.

Para buscar um objeto específico:

```bash
db.articles.find({ title: 'Sharding MongoDB' }).pretty()
description: 'Sharding MongoDB' }).pretty()
```

Para mais informações consulte: [http://docs.mongodb.org/manual](http://docs.mongodb.org/manual)
