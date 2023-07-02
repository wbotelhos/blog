---
date: 2012-12-17T00:00:00-03:00
description: "Configurando HTTP Authentication no Nginx"
tags: ["nginx", "authentication"]
title: "Configurando HTTP Authentication no Nginx"
---

Todo desenvolvedor tem seus projetos pessoais para dominar o mundo. E durante o desenvolvimento do mesmo, é importante em alguma hora se fazer os testes da aplicação, online, em produção. Mas isso não quer dizer que queremos que todos tenham acesso a mesma. Uma forma muito fácil de bloquear o acesso, sem precisar implementar algo sofisticado na própria aplicação, é usar a autenticação básica HTTP.

# Objetivo

Configurar uma HTTP Basic Authentication no [NGINX](http://nginx.org).

# Pre Requisitos

Estar com o NGINX já funcionando. Se você ainda não sabe como fazer isso, leia esse artigo: [Ruby, Unicorn e Nginx na Amazon EC2](http://wbotelhos.com/ruby-unicorn-e-nginx-na-amazon-ec2)

# Gerando a senha

Precisamos de alguma ferramenta para gerar uma sintáxe no qual é formada por um nome de usuário seguido de uma senha. Podemos fazer isso instalando a seguinte lib Apache Utils:

```bash
sudo apt-get install apache2-utils
```

Então iremos criar um arquivo chamado *.htpasswd* na raiz de onde se encontra o nosso NGINX instalado, no meu caso:

```bash
sudo htpasswd -c /usr/local/nginx/current/.htpasswd blogy
```

Basta confirmar a senha que deseja e pronto. O conteúdo fica algo como:

```bash
blogy:$dez1$9nvpv2/2$P/ZqwOWOeCKqeu290zpNd/
```

Se você não quiser instalar a biblioteca para gerar tal conteúdo, você pode usar o [htpassw generator](http://www.htaccesstools.com/htpasswd-generator).

# Configurando o NGINX

Basicamente precisamos de dois comando:

```bash
auth_basic 'Suas Credenciais';
auth_basic_user_file /usr/local/nginx/current/.htpasswd;
```

O primeiro comando é apenas uma mensagem que irá aparecer para o usuário. O segundo aponta para o arquivo de senha que criamos. Pegue este código e coloque no final da seção `location` principal do arquivo de configuração da sua aplicação contido na pasta *sites-enabled*:

```bash
server {
  ...

  location @app {
    ...
    auth_basic 'Suas Credenciais';
    auth_basic_user_file /usr/local/nginx/current/.htpasswd;
  }
}
```

Recarregue as configurações para que as alterações sejam aplicadas:

```bash
sudo service nginx reload
```

Pronto, basta acessar sua aplicação e será pedido um nome de usuário e uma senha para acesso.
