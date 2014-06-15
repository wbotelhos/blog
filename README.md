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
```

### Prepare the gemset

```bash
cd wbotelhos-com
rvm gemset create wbotelhos
cd .
bundle
```

### Prepare the database

```bash
rake db:drop:all && rake db:create:all && rake db:migrate
```

### Run the project

```bash
rails s
```

### Open the project

```bash
open http://localhost:3000
```

or

Acess `http://localhost:3000` via browser.

### Run the tests

```bash
rake db:test:prepare
rspec
```

# Tasks

### Dump production database locally

```bash
./script/database/production_to_development.sh production.password
```

### Dump local database to production

```bash
./script/database/development_to_production.sh production.password
```

### Deploy

- Code beautiful things;
- Commit your changes;
- `git push origin master`;
- `cap deploy`.

For more information: [Rails Deploy com Capistrano na Amazon EC2](http://wbotelhos.com/rails-deploy-com-capistrano-na-amazon-ec2)

## Contributors

[Check it out](http://github.com/wbotelhos/raty/graphs/contributors)

## Licence

[The MIT License](http://opensource.org/licenses/MIT)

## Love it!

Via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X8HEP2878NDEG&item_name=wbotelhos.com) or [Gittip](http://www.gittip.com/wbotelhos). Thanks! (:
