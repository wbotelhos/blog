---
date: 2012-11-20T00:00:00-03:00
description: "Rails Deploy com Capistrano na Amazon EC2"
tags: ["ruby", "rails", "deploy", "capistrano", "amazon", "aws", "ec2"]
title: "Rails Deploy com Capistrano na Amazon EC2"
---

No artigo passado, [Ruby, Unicorn e Nginx na Amazon EC2](http://wbotelhos.com/ruby-unicorn-e-nginx-na-amazon-ec2), montamos toda a estrutura necessária para rodar uma aplicação Ruby on Rails, porém não colocamos nada no ar. Essa tarefa será feita agora e iremos automatizar o deploy utilizando o [Capistrano](http://github.com/capistrano/capistrano).

### Objetivo

Criar uma aplicação Ruby on Rails e automatizar a publicação da mesma na Amazon EC2 utilizando o Capistrano.

### Criando a aplicação

Iremos criar uma aplicação crua, somente com uma página inicial que execute algum código Ruby para vermos o Unicorn funcionando. Entre na pasta onde você costuma deixar o seus projetos (workspace) e execute:

```ruby
rails new wbotelhos-com -STJ -d mysql
```
`S`: não instala nada do [Sprockets](https://github.com/sstephenson/sprockets), já que não vamos usar [Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html);
`T`: não instala nada do [Test Unit](http://test-unit.rubyforge.org), até porque usaríamos o [RSpec](http://rspec.info) né?; :P
`J`: não instala os arquivos JavaScripts de exemplo;
`-d mysql`: prepara a aplicação para rodar usando o [MySQL](http://www.mysql.com).

Mesmo com vários arquivos descartáveis no projeto criado, vamos seguir em frente e preencher o arquivo **Gemfile** com o seguinte conteúdo:

```ruby
source 'https://rubygems.org'

gem 'rails'
gem 'mysql2'

group :development do
  gem 'capistrano'
end

group :production do
  gem 'unicorn'
end
```

Aqui declaramos as gems necessárias, onde o **Capistrano** será usado apenas em desenvolvimento e o **Unicorn** apenas em produção. Com isso podemos fazer o download dessas dependências:

```ruby
bundle install
```

### Banco de dados

Vamos configurar a conexão ao banco de dados editando o arquivo `config/database.yml`:

```yaml
default: &defaults
  adapter: mysql2
  encoding: utf8
  reconnect: false
  pool: 5
  username: root
  password:
  host: localhost

development:
  <<: *defaults
  database: wbotelhos_development

test:
  <<: *defaults
  database: wbotelhos_test
```

Para facilitar usamos um block chamado **default** como configuração padrão e então o copiamos para o ambiente de desenvolvimento e test, ficando apenas o nome da base de dados distinta.

Este arquivo é para conexão local e não possui informações do banco de dados de produção por motivos óbvios. O que fazemos é deixar um *database.yml* guardado na pasta *conf* no servidor e durante o deploy o copiamos para dentro da aplicação *current/config*. Conecte-se ao servidor e crie este arquivo:

```bash
ssh -i ~/.ssh/wbotelhos.pem ubuntu@ec2-x-p-t-o.sa-east-1.compute.amazonaws.com
```

```bash
vim /var/www/wbotelhos/config/database.yml
```

```yaml
production:
  adapter: mysql2
  database: wbotelhos
  encoding: utf8
  host: localhost
  password: your_password
  pool: 5
  reconnect: true
  username: your_username
```

### MySQL

Para a instalação e configuração do MySQL, leia o artigo [Instalando e Configurando o MySQL](http://wbotelhos.com/instalando-e-configurando-o-mysql "Instalando e Configurando o MySQL")

### Capistrano (configuração - local)

Precisamos configurar o Capistrano localmente em nosso projeto. Para isso iremos acessar o projeto e instalar a gem:

```bash
cd ~/workspace/wbotelhos-com
gem install capistrano
```

E então executar a task `capify` no diretório corrente para serem criados os arquivos de deploy:

```bash
capify .
# [add] writing './Capfile'
# [add] writing './config/deploy.rb'
# [done] capified!
```

O arquivo **deploy.rb** conterá todos os comandos do deploy que serão descritos a seguir. Primeiramente iremos carregar a gem do Capistrano:

```ruby
require 'bundler/capistrano'
```

Daremos um nome para a aplicação que por praticidade poderia ser o nosso domínio. Porém esta variável **application** será utilizada em outros lugares pegando este endereço para deploy. Como estamos usando um Public DNS, vamos utilizá-lo, caso contrário o deploy seria aqui neste blog #lol:

```ruby
set :application, 'ec2-x-p-t-o.sa-east-1.compute.amazonaws.com '
```

A cada deploy que é feito, os arquivos atuais do servidor podem ser versionados e guardados em caso de *rollback*, logo podemos decidir quantas versões iremos manter de backup:

```ruby
set :keep_releases, 2
```

Nós iremos utilizar o [Github](http://github.com) para manter nosso projeto, logo devemos indicar qual o endereço do nosso repositório e de qual branch será feito o download:

```ruby
set :scm, :git
set :repository, 'git@github.com:wbotelhos/wbotelhos-com.git'
set :branch, 'master'
```

Uma ótima opção referente ao Github que podemos adicionar é o **remote_chache**. Esta opção evita que seja feito o clone de todo o repositório a cada deploy. Ao invés disso, é feito apenas um *fetch* das alterações, deixando assim, o deploy mais rápido:

```ruby
set :deploy_via, :remote_cache
```

O usuário que irá executar os comandos no servidor será o já utilizando **ubuntu**, sendo que iremos evitar utilizar o comando **sudo**:

```ruby
set :user, 'ubuntu'
set :runner, 'ubuntu'
set :group, 'ubuntu'
set :use_sudo, false
```

Vamos criar duas variáveis indicando a pasta contendo toda os arquivos referente a aplicação e uma indicando onde estará a aplicação de produção:

```ruby
set :deploy_to, '/var/www/wbotelhos'
set :current, "#{deploy_to}/current"
```

É possível mantermos nossa aplicação distribuida, utilizando a aplicação em um servidor e o banco de dados em outro, por exemplo. Porém nossa aplicação é centralizada apenas em um local, sendo assim, iremos utilizar o mesmo domínio, contido na variável `application`, nas três variáveis a seguir:

```ruby
role :web, application
role :app, application
role :db,  application, primary: true
```

Como o Github pedi para confirmarmos o host de conexão para que o mesmo fique no nosso **known host** e passar a ser confiável, vamos habilitar o **pseudo-tty** para que o host já seja aceito:

```bash
default_run_options[:pty] = true
```

Por fim precisamos fazer as configurações referente à autenticação (ssh). Como utilizamos uma chave privada para acessar a Amazon, iremos indicá-la para conseguirmos ter acesso ao servidor, no meu caso ela se encontra na pasta `.ssh`:

```ruby
ssh_options[:keys] = '~/.ssh/wbotelhos.pem'
```

Para ser possível baixarmos o código da aplicação precisamos da chave SSH cadastrada no Github. Quem faz a requisição do *clone* do repositório é o usuário ubuntu lá no servidor, e lá não temos tal chave, a temos apenas em nossa máquina de deploy. Para evitar a necessidade da cópia da chave local para o servidor existe uma opção chamada **forward_agent** que durante o deploy pega a chave local e a utiliza para requisitar o clone do repositório:

```ruby
ssh_options[:forward_agent] = true
```

Para verificar se sua chave esta configurada corretamente, execute:

```bash
ssh -T git@github.com
```

Se você estiver usando MacOSX, ao tentar fazer o deploy ao final deste artigo, obterá o seguinte erro:

```bash
** [forrostream.com :: out] Permission denied (publickey).
** [forrostream.com :: out] fatal: Could not read from remote repository.
** [forrostream.com :: out] Please make sure you have the correct access rights
** [forrostream.com :: out] and the repository exists.
```

Isso porque há um bug no Mac onde ele não reconhece a sua key local na keychain, tornando assim impossível o **forward_agent**. Mas graças a dica do mestre [Almir M3nd3s](https://twitter.com/m3nd3s), basta executar o comando a seguir para solucionar o problema:

```bash
ssh-add ~/.ssh/id_rsa
```

No caso minha chave esta com o nome padrão, sendo assim nem precisaria de passar o path.

> É legal deixar esse comando no seu *~/.bash_profile* evitando ter que re-executá-lo a cada terminal aberto.

### Capistrano (tarefas - local)

Com tudo configurado podemos criar as tarefas que executam o deploy. Inicialmente iremos executar o *setup* que monta a estrutura de pastas no servidor:

```ruby
cap deploy:setup
# command finished in --ms
```

Assim teremos os seguintes diretórios criados:

```
|── var
  └── www
    └── wbotelhos
      ├── config
      │   ├── database.yml
      │   └── unicorn.rb
      ├── current -> /var/www/wbotelhos/releases/xpto *
      ├── releases
      └── shared
         ├── bundle *
         ├── cached-copy *
         ├── log
         ├── pids
         └── system
```

As próprias pastas já se explicam. As pastas com asteríscos serão criadas posteriormente durante o deploy, sendo que a pasta *current* é um link simbólico para o último release no qual fizemos deploy. A pasta cached-copy só será criada se estivermos utilizando a opção `remote_cache`, que é o nosso caso.



Agora vamos criar a task que manipula o Unicorn:

```ruby
namespace :deploy do
  task :start do
    %w[config/database.yml].each do |path|
      from  = "#{deploy_to}/#{path}"
      to    = "#{current}/#{path}"

      run "if [ -f '#{to}' ]; then rm '#{to}'; fi; ln -s #{from} #{to}"
    end

    run "cd #{current} && RAILS_ENV=production && GEM_HOME=/opt/local/ruby/gems && bundle exec unicorn_rails -c #{deploy_to}/config/unicorn.rb -D"
  end

  task :stop do
    run "if [ -f #{deploy_to}/shared/pids/unicorn.pid ]; then kill `cat #{deploy_to}/shared/pids/unicorn.pid`; fi"
  end

  task :restart do
    stop
    start
  end
end
```

Declaramos as tasks chamadas **start**, **stop** e **restart** que é a execução das duas anteriores. Essas tasks são declaradas no *namespace* **deploy**, sendo assim o acesso fica sendo algo como **cap deploy:start**.

Na task *start* começamos fazendo um link simbólico do arquivo **database.yml** para dentro da versão do projeto que esta no ar (current). Caso este link já exista, nós o apagamos antes para garantir a integridade do arquivo. Perceba que estamos usando um `each`, assim podemos adicionar outros arquivos que queiramos fazer o link simbólico. Em seguida inicializamos o Unicorn, executando alguns comandos:

- Acessar a pasta do projeto corrente;
- Setar a variável de ambiente, que diz qual o tipo de ambiente atual, para produção;
- Indicar onde se encontram as gems no SO; e
- Iniciar o Unicorn passando o caminho do arquivo **unicorn.rb** que criamos.

Na task *stop* simplesmente pegamos o número do [PID](http://linux.about.com/cs/linux101/g/processlparproc.htm) do processo do Unicorn e então o matamos.

> Se ocorrer um erro no qual o script não consegue parar o Unicorn, verifique se não há o arquivo *unicorn.pid* na pasta *./shared/pids*, que contenha um PID não mais em execução e o apague.

### Callbacks

Antes ou depois de alguma tarefa, podemos adicionar *callbacks* utilizando a palavra chave **before** ou **after**. Uma tarefa já pronta e essencial para ser executada após cada deploy é a tarefa **cleanup**, esta que limpa os *releases* antigos obedecendo o `:keep_releases` que por default é 5, mas que alteramos. Essa tarefa é um dos motivos de termos configurado o `use_sudo` para `false`, pois ela tenta executar com tal comando.

Agora podemos verificar se tudo foi configurado corretamente:

```ruby
cap deploy:check
# You appear to have all necessary dependencies installed
```

### Github

Lembre-se que o código que será enviado para o servidor é o código que esta versionado no **master** do Github, então precisamos fazer o commit do nosso projeto e subí-lo no Github primeiro:

```bash
git init
git add .
git commit -am 'first commit'
git remote add origin https://github.com/wbotelhos/wbotelhos-com.git
git push -u origin master
```

E por fim, seguindo a dica do [Fillipe](http://www.wbotelhos.com/2012/11/20/rails-deploy-com-capistrano-na-amazon-ec2#comment-416 "Dica do Fillipe"), faremos o nosso primeiro deploy com o comando:

```bash
cap deploy:cold
```

O `:cold` faz tudo que o `cap deploy` faz além de verificar as configurações do banco de dados e roda as migrations. Para os demais deploy utilize apenas:

```bash
cap deploy
```

Agora acesse o seu DNS Public e curta a sua app!

```bash
open http://ec2-x-p-t-o.sa-east-1.compute.amazonaws.com
```
