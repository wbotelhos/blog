---
date: 2012-04-04T00:00:00-03:00
description: "Iniciando com Testes Ruby Usando RSpec"
tags: ["ruby", "rspec"]
title: "Iniciando com Testes Ruby Usando RSpec"
---

Já deixou de ser normal aplicações que não possuem bateria de testes para garantir as funcionalidades do sistema. Mas devido cultura, chefia e até problemas técnicos da própria equipe, a falta de testes acaba sendo inevitável.

No post [http://wbotelhos.com/melhorando-seus-testes-em-ruby-com-spork-e-guard](http://wbotelhos.com/melhorando-seus-testes-em-ruby-com-spork-e-guard) falei sobre ferramentas mais avançadas para melhorar a experiência com os testes, porém este post servirá para aqueles que estão iniciando ou que desejam entender um pouco em como criar e organizar seus testes, como um QA (Analista de Qualidade), por exemplo.

# Objetivo

Configurar o ambiente para o RSpec e criar um modelo básico de organização dos testes, deixando tudo preparado para testes mais avançados.

# Criando o projeto

Vamos criar um projeto Rails exemplo para trabalharmos em cima dele. Execute:

```bash
rails new iniciando-com-testes-ruby-usando-rspec -STJ
```

`S`: não instala nada do [Sprockets](https://github.com/sstephenson/sprockets), já que não vamos usar [Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html);
`T`: não instala nada do [Test Unit](http://test-unit.rubyforge.org), pois vamos usar o [RSpec](http://rspec.info) né?; :P
`J`: não instala os arquivos JavaScripts de exemplo.

```bash
cd iniciando-com-testes-ruby-usando-rspec
```

Ok, já temos o projeto.

# Configuração para os testes

É normal chamarmos os nossos testes de "specs", por isso deixamos todos os nossos testes dentro de uma pasta na raiz chamada `spec` no singular.

```bash
mkdir spec
```

Dentro desta pasta temos um arquivo especialmente para configurar os testes chamado `spec_helper.rb`, nele vamos fazer algumas configurações:

```bash
touch spec/spec_helper.rb
```

```ruby
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path '../../config/environment', __FILE__
require 'rspec/rails'
```

1. Dizemos que o ambiente durante os teste será o `test`;
2. Load do arquivo de *environment* que basicamente sobe a app; e
3. Load da gem [RSpec Rails](https://github.com/rspec/rspec-rails) para usarmos em nossos testes.

Como estamos usando o RSpec, devemos adicionar essa gem no Gemfile:

```ruby
source 'https://rubygems.org'

gem 'rails'
gem 'rspec-rails'
gem 'sqlite3'
```

E por fim criar o `config/database.yml` que se faz necessário, pois lá dizemos qual base de dados utilizar durante os testes.

```yaml
development: &default
  adapter: sqlite3
  database: db/development.sqlite3
  pool: 5
  timeout: 5000

test:
  <<: *default
  database: db/test.sqlite3
```

Declaramos a configuração de `development` como padrão e a reaproveitamos usando a mesma configuração para os testes.

## Estrutura de diretórios

Vamos criar uma classe para o nosso exemplo:

```bash
mkdir -p app/models
touch app/models/article.rb
```

É padrão termos um arquivo de teste para cada arquivo existente. O arquivo de testes deve estar dentro da pasta `spec` com o mesmo caminho que o arquivo a ser testado, porém com o sufixo `_spec`.

```bash
mkdir -p spec/app/models
touch    spec/app/models/article_spec.rb
```

Veja que o caminho é idêntico ao do modelo. Indicamos que este arquivo é de teste por conta do sufixo `_spec`. Para um arquivo `app/helper/custom_helper.rb` teríamos o arquivo de teste: `spec/app/helper/custom_helper_spec.rb`.

O artigo terá um método que dirá qual a lingaguem tratada no artigo a partir do título:

```ruby
class Article
  def self.language(title)
    return 'Ruby'   if title =~ /.*ruby.*/
    return 'Python' if title =~ /.*python.*/
  end
end
```

Para bolarmos os teste devemos nos perguntar **o que o método deve fazer**, **em qual situação a aplicação estará** e **qual será o resultado**.

1. Quando passarmos um título que tenha a palavra 'ruby' devemos obter o retorno 'Ruby';
2. Quando passarmos um título que tenha a palavra 'python devemos obter o retorno 'Python'.

# Estruturando os arquivos de teste

Para toda classe de teste, devemos carregar o arquivo `spec_helper.rb`, pois ele possui códigos necessários. Então descrevemos o que estamos testando:

```bash
vi spec/app/models/article_spec.rb
```

```ruby
require 'spec_helper'

describe 'Article' do
end
```

Para carregar o `spec_helper` não precisamos de dizer a extensão `.rb`. Logo em seguida utilizamos a palavra chave `describe` para **descrever** a classe `Article` que criamos. Da mesma forma que descrevemos um arquivo, descrevemos métodos que estão dentro desse arquivo. Podemos usar quantos `describe` quisermos:

```ruby
require 'spec_helper'

describe 'Article' do
  describe 'language method' do
  end
end
```

O teste em si fica dentro de um bloco de código chamado `it`, ficando:

```ruby
require 'spec_helper'

describe 'Article' do
  describe 'language method' do
    it 'returns "Ruby" when title is about Ruby' do
    end

    it 'returns "Python" when title is about Python' do
    end
  end
end
```

Agora sim o teste tem um comportamente. Mas há algo não muito legal; Repare que em ambas as *specs* descrevemos o que esperamos do teste e em qual situação a aplicação estará. Essas situação podem ser melhores contextualizadas utilizando a palavra chave `context`:


```ruby
require 'spec_helper'

describe 'Article' do
  describe '#language' do
    context 'when title is about Ruby' do
      it 'returns "Ruby"' do
      end
    end

    context 'when title is about Python' do
      it 'returns "Python"' do
      end
    end
  end
end
```

Agora ficou mais fácil de ler, pois descrevemos o `Article` e o método `language` na situação onde temos a palavra "Ruby" ou "Python" no título e em cada um deles devemos ter um resultado específico. Veja que mudei o segundo describe para simplesmente o nome do método com um tralha (#) antes. Isso porque temos a opção de mostrar tudo que foi escrito nos `describe`, `context` e `it`. Na forma padrão, ao rodar os testes temos:


```bash
rspec spec
```

```bash
..

Finished in 0.00334 seconds
2 examples, 0 failures
```

Os dois pontos, significa que temos dois testes. Ou seja, rodaram 2 testes (examples) sem nenhuma falha (failures) em apenas 0.00334 segundos.

Para imprimir a forma descritiva, use a opção -f (--format) e passe o formato `d` (documentation):

```bash
rspec spec --format documentation
```

Ou a forma resumida:

```bash
rspec spec -f d
```

Então vemos a nossa descrição completa:

```bash
Article
  #language
    when title is about Ruby
      returns "Ruby"
    when title is about Python
      returns "Python"

Finished in 0.00422 seconds
2 examples, 0 failures
```

Adicione o parâmetro `--color` para deixar a saída colorida. Se não quiser ficar fazendo isso para todo comando, basta criar um arquivo chamado `.rspec` com os parâmetros que você deseja na raiz do projeto:

```bash
echo '--format documentation --colour' > .rspec
```

Este arquivo só valerá para o projeto corrente. Se ficar na sua *home* valerá para qualquer projeto. A primeira opção tem prioridade.

# Expectations

As *expectations* são o que esperamos dos testes. Na versão mais antiga do RSpec, a palavra chave para "esperar" alguma coisa era `should`, nas atuais é `expect`. Dentro do `it` as fazemos:

```ruby
it 'returns "Ruby"' do
  expect(Article.language 'Aprendendo Ruby').to eq 'Ruby'
end
```

Veja que dentro da *expectation* executamos o código processador, então esperamos que o resultado seja (`to`) igual (`eq`) a "Ruby". Fazemos o mesmo para o segundo teste:

```ruby
it 'returns "Python"' do
  expect(Article.language 'Aprendendo Python').to eq 'Python'
end
```

E então rodamos todos:

```ruby
rspec
```

> Se estivermos na raiz do projeto, o comando `rspec`já sabe que deve procurar dentro da pasta `spec`, logo não é necessário especificar.

```bash
Article
  #language
    when title is about Ruby
      returns "Ruby" (FAILED - 1)
    when title is about Python
      returns "Python" (FAILED - 2)

Failures:

  1) Article#language when title is about Ruby returns "Ruby"
     Failure/Error: expect(Article.language 'Aprendendo Ruby').to eq 'Ruby'

       expected: "Ruby"
            got: nil

       (compared using ==)
     # ./spec/app/models/article_spec.rb:7:in `block (4 levels) in <top (required)>'

  2) Article#language when title is about Python returns "Python"
     Failure/Error: expect(Article.language 'Aprendendo Python').to eq 'Python'

       expected: "Python"
            got: nil

       (compared using ==)
     # ./spec/app/models/article_spec.rb:13:in `block (4 levels) in <top (required)>'

Finished in 0.00734 seconds
2 examples, 2 failures

Failed examples:

rspec ./spec/app/models/article_spec.rb:6 # Article#language when title is about Ruby returns "Ruby"
rspec ./spec/app/models/article_spec.rb:12 # Article#language when title is about Python returns "Python"
```

O código de erro do teste é bem descritivo:

```bash
1) Article#language when title is about Ruby returns "Ruby"

...

expected: "Ruby"
     got: nil
```

Aqui a saída ficou bem clara, já que usamos os `describe` e `context` corretamente. E veja que o resultado realmente foi o contrário, pois esperávamos a palavra "Ruby", mas recebemos `nil`.

> Muitas pessoas costumam iniciar o texto do `it` com a palavra *should*, porém para uma leitura natural, creio ser melhor conjugar o verbo na terceira pessoa, ficado "it returns" em vez de "it should return".

Voltando no nosso código, podemos ver o problema:

```ruby
return 'Ruby'   if title =~ /.*ruby.*/
return 'Python' if title =~ /.*python.*/
```

Estamos verificando somente com as letras minúsculas. Podemos melhorar isso dizendo para a [Expressão Regular](http://pt.wikipedia.org/wiki/Express%C3%A3o_regular) não distinguir maiúsculas e minúsculas passando o parâmetro `i` (insensitive)

```ruby
return 'Ruby'   if title =~ /.*ruby.*/i
return 'Python' if title =~ /.*python.*/i
```

```bash
rspec
```

```bash
Article
  #language
    when title is about Ruby
      returns "Ruby"
    when title is about Python
      returns "Python"

Finished in 0.00511 seconds
2 examples, 0 failures
```

Green! Nossos testes passaram. Agora vamos adicionar um último teste para o código nos dizer quando não encontrou uma linguagem de programação:

```ruby
context 'when title is about an unknow language' do
  it 'returns a not found message' do
    expect(Article.language 'Aprendendo PHP').to eq 'Ops! Não é um artigo sobre programação.'
  end
end
```

Como utilizamos palavras acentuadas no arquivo, devemos declarar o seguinte código na primeira linha:

```ruby
# coding: utf-8
```

> Pode ser qualquer_coisa + coding: utf-8, ou seja: `enconding: utf-8`, `bolinhacoding: utf-8` e afins. Prefiro usar o mais curto.

```ruby
rspec
```

```bash
 expected: "Ops! Não é um artigo sobre programação."
      got: nil

...

rspec ./spec/app/models/article_spec.rb:20 # Article#language when title is about an unknow language returns a not found message
```

Bem, o nosso código esta retornando `nil` vamos consertar isso:

```ruby
# coding: utf-8

class Article
  def self.language(title)
    return 'Ruby'   if title =~ /.*ruby.*/i
    return 'Python' if title =~ /.*python.*/i

    'Ops! Não é um artigo sobre programação.'
  end
end
```

Agora para rodarmos exatamente o teste que quebrou, copie as últimas saída do console, pois lá, se você reparar, terá o caminho do arquivo de teste e o número da linha no qual ele se encontra, assim você roda ele isoladamente:

```bash
rspec ./spec/app/models/article_spec.rb:20 # Article#language when title is about an unknow language returns a not found message
```

Se você copiar a linha toda, não tem problema, pois o restante é comentário por conta do `#`, assim o terminal ignora.

```bash
Article
  #language
    when title is about Ruby
      returns "Ruby"
    when title is about Python
      returns "Python"
    when title is about an unknow language
      returns a not found message

Finished in 0.00477 seconds
3 examples, 0 failures
```

Green! Todos os nossos testes estão passando.

Uma última melhoria que podemos fazer é evitar a repetição do nome da classe que estamos testando, no caso `Article`. Podemos fazer isso descrevendo o objeto `Article` mesmo, em vez de uma String 'Article' e usar essa referência:

```ruby
describe Article do
  ...
  expect(described_class.language 'Aprendendo Ruby').to eq 'Ruby'
  ...
end

```

Veja que usamos a palavra `described_class` que intuitivamente referencia a classe que estamos descrevendo. Se trocarmos o nome da classe que estamos descrevemos, não precisaremos trocar todos os outros nomes.

Tenha em mente que escrever teste não é perder tempo, e sim ganhar. Pois um código que esta funcionando, nunca mais irá parar de funcionar sem que você saiba. Quando você tem uma bateria de testes grandes e acha um bug, é prazeroso ir lá e adicionar mais um teste e dormir tranquilo sabendo que removeu mais uma falha. Além disso, a sua equipe, que pode não conhecer todo o seu projeto, ficará feliz em ter um feedback caso faça algo errado.

Veja esse projeto no Github: [https://github.com/wbotelhos/iniciando-com-testes-ruby-usando-rspec](https://github.com/wbotelhos/iniciando-com-testes-ruby-usando-rspec)
