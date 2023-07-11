---
date: 2012-10-23T00:00:00-03:00
description: "Ruby, Unicorn e Nginx na Amazon EC2"
tags: ["ruby", "unicorn", "nginx", "amazon", "ec2", "aws"]
title: "Ruby, Unicorn e Nginx na Amazon EC2"
---

Se você esta lendo este artigo através do blog, então esta acessando uma estrutura igual a que iremos criar. Irei mostrar como instalar e configurar todos os elementos citados no título deste post, passo-a-passo.

## Objetivo

Será mostrado como instalar o Ruby junto ao Rails para ser rodado no Unicorn e servido pelo NGINX na Amazon EC2.

## Instância da Amazon EC2

Para criar a instância, siga o artigo [Amazon EC2 com Java, MySQL e Tomcat](http://wbotelhos.com/amazon-ec2-com-java-mysql-e-tomcat), porém escolha uma instância mais recente do **Ubuntu**. Enquanto escrevo ou atualizo este artigo, a versão 14.04.

## Setup

Após logarmos no servidor com algo do tipo:

```sh
ssh -i ~/.ssh/{{app_name}}.pem ubuntu@{{amazon_dns}}
```

Vamos fazer download de um arquivo do projeto [Installer](https://github.com/wbotelhos/installers):

```sh
wget https://raw.githubusercontent.com/wbotelhos/installers/master/amazon/init.sh
```

E então, para preparar o ambiente com atualização das libs do Ubuntu e afins, vamos executar:

```sh
chmod +x init.sh
sudo ./init.sh
```

## Git

Vamos executar a tarefa de instalação e ativação com a seguinte versão:

```sh
./git/git.sh activate 1.9.0
```

## Configuração de Path


```sh
sudo ./amazon/path.sh
```

## Ruby

<img class="align-center" src="http://www.ruby-lang.org/images/logo.gif" alt="Ruby" title="Ruby" width="331" height="119" style="margin-bottom: 30px;" />

Se você já pensou no [RVM](https://rvm.io), sem problemas. Também utilizo o mesmo localmente, porém no servidor iremos compilar tudo, deixando o sistema bem enxuto. (:

Vamos executar a tarefa de instalação e ativação com a seguinte versão:

```sh
sudo ./ubuntu/ruby/ruby.sh activate 2.1.2
```

> Vá tomar um café...

Ao fim, faça logout e reconecte-se ao servidor:

```sh
exit
```

Verifique se tudo deu certo:

```sh
ruby -v
# ruby 2.1.2p95 (2014-05-08 revision 45877) [x86_64-linux]
```

## RubyGems

<img class="align-center" src="http://rubygems.org/images/logo.png" alt="RubyGems"  title="RubyGems" style="background-color: #000; border-radius: 21px; margin-bottom: 30px;   padding: 10px 20px" />

O [RubyGems](http://rubygems.org) é um repositório de gems no qual iremos fazer o download automáticos das nossas gems. Para criar no home do usuário o arquivo de configuração `.gemrc`, execute:

```sh
./rubygems/rubygems.sh install
```

## Bundler

O [Bundler](http://gembundler.com) é uma ferramenta para garantir a atualização correta das nossas gems, e iremos instalá-lo:

```sh
./bundler/bundler.sh install
```

## NGINX

<img class="align-center" src="http://t1.gstatic.com/images?q=tbn:ANd9GcTu3JPjIGkKolgPllQv-1sfaJF7HzYQ9i1ZltClfyvDTKMM6l_pZQ" alt="NGINX" title="NGINX" style="margin-bottom: 30px;" />

Temos boas opção de servidores web para aplicações Ruby como é o caso do [Apache](http://www.apache.org), mas por vários motivos iremos utilizar o [NGINX](http://nginx.org).

Como já estamos configurando o servidor, precisamos já decidir onde iremos armazenar o nosso site e qual o nome de usuário que será usado para acessar os arquivos do mesmo. Por padrão, o site é armazenado em `/var/www` e o nome de usuário é `ubuntu` por conta do padrão da Amazon. Você pode alterar isso na seção `Configurations` do arquivo `./nginx/nginx.sh`.

Da mesma forma podemos adicionar ou remover módulos do NGINX, para isso, edite o arquivo já citado e altere o método `configure` com os módulos desejados.


Vamos executar a tarefa de instalação e ativação com a seguinte versão:

```sh
./nginx/nginx.sh activate 1.7.4
```

Verifique se tudo deu certo:

```sh
nginx -v
# nginx version: nginx/1.7.4
```

É possível ver as informações completas incluindo os módulos instalando utilizando o parâmetro `V`.

```sh
nginx -V
```

### Configurations

Contendo as configurações básicas, todos se encontram na `./nginx` onde alguns contêm variáveis que são substituidas de acordo com as configurações no arquivo `nginx.sh` como, por exemplo, `pid {{pid_file}};`.

Para configurar tudo de forma automática, após você definir suas configurações, execute o seguinte *job*:

```sh
./nginx/nginx.sh configure
```

### Nginx (arquivo do nosso sistema)

Como podemos ter mais de um sistema rodando no mesmo NGINX, devemos criar um arquivo de configuração para cada um. Vamos criar um arquivo para o blog [wbotelhos.com](http://wbotelhos.com):

```sh
sudo vim /etc/nginx/sites-enabled/wbotelhos.conf
```

E colar a seguinte configuração:

```sh
upstream app {
  server 127.0.0.1:5000;
  server 127.0.0.1:5001;
  server 127.0.0.1:5002;
}

server {
  # A porta no qual o servidor esta escutando as requisições.
  listen 80;

  # IP ou domínio definido para apontar para o nosso virtual host.
  server_name ec2-x-p-t-o.sa-east-1.compute.amazonaws.com 0.0.0.0;

  # Configurar o root para a pasta "public" é muito importante quando queremos utilizar arquivos
  # estáticos sem passar pelo Rails como é o caso dos meus plugins (wbotelhos.com/raty).
  # Como o root da aplicação esta apontando para "public", logo wbotelhos.com/raty aponta
  # para uma pasta dentro de "public/raty" que é acessada diretamente fora do Rails.
  # E o melhor é que se você acessar apenas wbotelhos.com com barra no final ou não
  # o que você definiu no seu routes.rb será processado: `root to: 'articles#index'`
  root /var/www/wbotelhos/current/public;

  # O "index" é complemento da configuração "root", onde ao acessar wbotelho.com/raty seremos
  # redirecionados automáticamente para a página public/raty/index.html.
  # Precisamos dessa configuração, pois não conseguimos acessar a página html diretamente.
  index index.html;

  # Tamanho máximo permitido para requisção indicado pelo Content-Length. Default: 1M.
  client_max_body_size 5M;

  location / {
    proxy_redirect   off;
    proxy_set_header Host $http_host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Real-IP  $remote_addr;

    if ($request_uri ~* "\.(ico|css|js|gif|jpe?g|png)\?[0-9]+$") {
      access_log off;
      add_header Cache-Control public;
      expires    max;
      break;
    }

    if (-f $request_filename/index.html) {
      rewrite (.*) $1/index.html break;
    }

    if (-f $request_filename.html) {
      rewrite (.*) $1.html break;
    }

    if (!-f $request_filename) {
      proxy_pass http://app;
      break;
    }
  }

  error_page  500 502 503 504  /500.html;

  location = /500.html {
    root /var/www/wbotelhos/current/public;
  }
}
```

Você deve substituir o Public DNS **ec2-x-p-t-o.sa-east-1.compute.amazonaws.com** pelo DNS da instância que você criou:

```sh
server_name ec2-x-p-t-o.sa-east-1.compute.amazonaws.com 0.0.0.0;
```

E então estamos utilizando o diretório **wbotelhos**, no qual o *root* será o diretório público:

```sh
root /var/www/wbotelhos/current/public;
```

### Nginx (Upstart)

Vamos criar um arquivo de inicialização do Nginx utilizando o [Upstart](http://upstart.ubuntu.com):

```sh
sudo vim /etc/init/nginx.conf
```

O conteúdo será o seguinte:

```sh
description 'nginx webserver'

start on startup
stop on shutdown

respawn
expect fork
exec /opt/local/sbin/nginx
```

Vamos garantir que o nosso usuário tem acesso aos arquivos de configuração:

```sh
sudo chown ubuntu:ubuntu /var/log/nginx/error.log
sudo chown ubuntu:ubuntu /etc/nginx/nginx.conf
```


E então verificar se tudo esta correto:

```sh
nginx -t
```

Bem provável ser lançado algumas mensagens não positivas.

```sh
nginx: [emerg] open() "/var/run/nginx.pid" failed (13: Permission denied)
```

Ainda não há PID criado, pois não estamos rodando o NGINX, ignore e inicie o serviço:

```sh
sudo start nginx
# nginx start/running, process 23757
```

Certifique-se que o serviço esta rodando:

```sh
ps aux | grep nginx
```

Para parar use o stop:

```sh
sudo stop nginx
# nginx stop/waiting
```

E para reinicar use o restart:

```sh
sudo restart nginx
# nginx stop/waiting
# nginx start/running, process 23757
```

Agora faça o teste acessando o DNS público pelo browser:

```sh
open http://ec2-x-p-t-o.sa-east-1.compute.amazonaws.com
# 404 Not Found --- nginx/1.5.8
```

### Unicorn

<img class="align-center" src="https://github.com/images/error/angry_unicorn.png" alt="Unicorn" title="Unicorn" style="margin-bottom: 30px;" />

Configurar o [Unicorn](http://unicorn.bogomips.org/) é bem simples. Ele é uma gem que declaramos no Gemfile do nosso projeto. Vamos criar o seu arquivo de inicialização:

```sh
sudo vim /etc/init/unicorn.conf
```

```sh
description 'unicorn server'

pre-start script
  mkdir -p /var/run/unicorn
  chown ubuntu:ubuntu /var/run/unicorn
  chmod 770 /var/run/unicorn

  mkdir -p /var/log/unicorn
  chown ubuntu:ubuntu /var/log/unicorn
  chmod 770 /var/log/unicorn
end script

start on startup
stop on shutdown

exec sudo -u ubuntu -g ubuntu sh -c "cd /home/ubuntu/www/wbotelhos/current && RAILS_ENV=production GEM_HOME=/opt/local/ruby/gems bundle exec unicorn_rails -c /home/ubuntu/www/wbotelhos/config/unicorn.rb"

respawn
```

Repare que já apontamos alguns caminhos como a pasta *current* que manterá a versão corrente do nosso sistema e a pasta *config* que além de diversas configurações terá um arquivo de configuração do Unicorn.

Ainda não temos a pasta *wbotelhos* e nem a pasta *config*, então vamos criá-las:

```sh
mkdir -p /var/www/wbotelhos/config
```

E então podemos criar as configurações:

```sh
vim /var/www/wbotelhos/config/unicorn.rb
```

```sh
worker_processes 3

listen 5000
listen 5001
listen 5002

preload_app true

timeout 30

pid               '/var/www/wbotelhos/shared/pids/unicorn.pid'
stderr_path       '/var/www/wbotelhos/shared/log/unicorn.error.log'
stdout_path       '/var/www/wbotelhos/shared/log/unicorn.out.log'
working_directory '/var/www/wbotelhos/current'
```

Estas configurações basicamente são os caminhos dos arquivos de log e o diretório onde o servidor irá atuar, além da quantidade de processos e portas em que ele ficará escutando.

Deste modo estamos com o Ruby, NGINX e Unicorn prontos para rodar uma aplicação. É claro que iremos precisar de uma tarefa de deploy usando por exemplo, o [Capistrano](https://github.com/capistrano/capistrano), que será o tema do próximo post. (:
