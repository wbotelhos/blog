# Blog on Rails

[http://wbotelhos.com](http://wbotelhos.com) on Rails.

[![Travis CI status](https://travis-ci.org/wbotelhos/wbotelhos-com.png?branch=master)](https://travis-ci.org/wbotelhos/wbotelhos-com "Travis CI")
[![Code Climate](https://codeclimate.com/github/wbotelhos/wbotelhos-com.png)](https://codeclimate.com/github/wbotelhos/wbotelhos-com "Code Climate")
[![Support wbotelhos.com](http://img.shields.io/gittip/wbotelhos.svg)](https://www.gittip.com/wbotelhos "Git Tip")

## Usage

### Install MySQL

[Instalando e Configurando o MySQL](http://wbotelhos.com/2012/10/17/instalando-e-configurando-o-mysql)

### Clone the project

```bash
git clone https://github.com/wbotelhos/wbotelhos-com.git
cd wbotelhos-com
```

### Prepare the gemset

```bash
rvm gemset create wbotelhos
cd .
NOKOGIRI_USE_SYSTEM_LIBRARIES=1 bundle
```

### Prepare the database

```bash
rake db:create:all && rake db:migrate && rake db:setup
```

### Run the project

```bash
rails s
```

### Open the project

Acess http://localhost:3000

### Run the tests

```bash
rake db:test:prepare
rspec
```

## Licence

The MIT License

## Donate

You can do it by [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X8HEP2878NDEG&item_name=Blog-BR). Thanks! (:
