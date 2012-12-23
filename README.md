# Blog on Rails

[http://wbotelhos.com.br](http://wbotelhos.com.br) on Rails.

![Travis CI status](https://travis-ci.org/wbotelhos/wbotelhos-com-br.png?branch=master "Travis CI")

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/wbotelhos/wbotelhos-com-br "Code Climate")

## Usage

### Install MySQL

[Instalando e Configurando o MySQL](http://wbotelhos.com/2012/10/17/instalando-e-configurando-o-mysql)

### Clone and prepare the database

```bash
git clone https://github.com/wbotelhos/wbotelhos-com-br.git
cd wbotelhos-com-br
bundle install
rake db:create:all; rake db:migrate; rake db:setup
open http://localhost:3000
```

### Run the tests

```bash
rake db:test:prepare
rspec spec
```

## Licence

The MIT License

Copyright (c) 2012 Washington Botelho

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Donate

You can do it by [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X8HEP2878NDEG&item_name=Blog-BR). Thanks! (:
