---
date: 2012-01-07T00:00:00-03:00
description: "Melhorando Seus Testes em Ruby com Spork e Guard"
tags: ["ruby", "spork", "guard"]
title: "Melhorando Seus Testes em Ruby com Spork e Guard"
---

Com o decorrer de qualquer projeto a bateria de testes vão crescendo com os testes de unidade, funcionais, integração, aceitação e afins. Além disso criamos diversas configurações das quais carregam bibliotecas auxiliares, inclusive o [Rails](http://rubyonrails.org/ "Rails"). Com isso começamos a perceber uma lentidão na hora de rodar os testes. Dado esse problema veremos como melhor nossos testes em performance e facilidade de execução.

### Objetivo

Tornar os testes mais rápidos e mais fáceis de serem executados utilizando o [Spork](https://github.com/sporkrb/spork "spork") e o [Guard](https://github.com/guard/guard "Guard")

### Spork

Normalmente em nossas specs, carregamos o famoso **spec_helper.rb**, pois é nele que ficam declaradas algumas bibliotecas necessárias para rodar os testes como, por exemplo, o [Capybara](https://github.com/jnicklas/capybara "Capybara"), [Database Cleaner](https://github.com/bmabey/database_cleaner "Database Cleaner"), [RSpec](https://github.com/dchelimsky/rspec "RSpec") e o [Rails](http://rubyonrails.org/ "Rails"). E todo este carregamento ocorre cada vez que rodamos os testes, o que pode ser muito demorado dependendo do tamanho do projeto.

O [Spork](https://github.com/sporkrb/spork "Spork") basicamente faz todo este carregamento uma única vez em seu próprio servidor, o *Distributed object system for Ruby*, assim, quando os testes forem executados, tudo já estará carregado poupando um bom tempo.

Para manipular o Spork iremos utilizar a gem [guard-spork](https://github.com/guard/guard-spork "Guard Spork") que faz uma abstração pra gente:

```rb
group :development do
  gem 'guard-spork', '~> 1.4.0'
end
```

E então podemos iniciar a sua configuração:

```sh
bundle install
guard init spork
```

Um arquivo chamado **Guardfile**, nascido da combinação Guard + Spork, será criado na raiz do projeto e explicado logo adiante:

```rb
# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch('config/environments/test.rb')
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb') { :rspec }
  watch('test/test_helper.rb') { :test_unit }
  watch(%r{features/support/}) { :cucumber }
end
```

### Guard

O [Guard](https://github.com/guard/guard "Guard"), como o nome mesmo já sugere, é um camarada que fica vigiando alterações nos arquivos do SO que dispara ações onde podemos executar alguns eventos. No arquivo Guardfile o Guard "assistindo" alguns arquivos como:

```rb
watch('config/application.rb')
```

Como esses *watcher* estão dentro do block `guard 'spork'`, quando algum dos arquivos descrito for alterado, o Spork será recarregado. Agora que já sabemos um pouco do Spork e do Guard, vamos personalizar o nosso Guardfile:

```rb
guard :spork, wait: 120, test_unit: false, cucumber: false, rspec_env: { 'RAILS_ENV' => 'test' } do
  watch(%r(^config/initializers/.+\.rb$))
  watch('config/application.rb')
  watch('config/environments/test.rb')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')
end
```

No bloco `:spork` adicionamos algumas configurações:

`wait`: tempo de espera até o servidor subir. Para aplicações mais pesadas isso é importante;
`test_unit`: não iremos utilizá-lo, pois vamos usar o RSpec;
`cucumber`: não iremos gerenciar os testes de [Cucumber](https://github.com/cucumber/cucumber "Cucumber");
`rspec_env`: dissemos ao Spork que durante os testes de RSpec o RAILS_ENV terá o valor "test". E fique atento a isto, pois se durante os testes de Cucumber, por exemplo, fizéssemos:

```rb
ENV['RAILS_ENV'] ||= 'cucumber'
```

E na configuração do Spork colocássemos:

```rb
cucumber_env: { 'RAILS_ENV' => 'test' }
```

O Guard não seria ativado, pois ele estaria esperando o valor **test** na variável de ambiente "RAILS_ENV", sendo que estaríamos setando **cucumber** durante os testes.

O reload do DRb, só será feito quando a alteração de um arquivo puder afetar o comportamento do Spork. Agora precisamos automatizar o RSpec:

Primeiramente vamos adicionar a gem [guard-rspec](https://github.com/guard/guard-rspec "Guard RSpec") no Gemfile:

```rb
group :development do
  gem 'guard-rspec', '~> 2.3.1'
end
```

E adicionar o bloco de configuração do RSpec no Guardfile:

```rb
guard :rspec, cli: '--drb --color --format doc', all_on_start: false, all_after_pass: false do
  watch(%r(^spec/.+_spec\.rb$))
  watch(%r(^app/models/(.+)\.rb$))  { |m| "spec/models/#{m[1]}" }
  watch(%r(^app/models/(.+)\.rb$))  { |m| "spec/features/#{m[1]}" }
  watch('spec/spec_helper.rb')      { 'spec' }
end
```

Neste block utilizamos a propriedade `cli` para dizer o que será automaticamente executado na linha de comando durante a execução do `rspec`:

`--drb`: dize que iremos rodar os testes no Spork DRb server;
`--color`: opção para colorir o output dos testes;
`--format doc`: para deixar o label dos testes em formato de documento;
`all_on_start`: desligamos para não ser rodado todos os testes de RSpec assim que o Spork subir;
`all_after_pass`: desligamos para não rodar todos os testes após um simples testes passar.

E então fazermos alguns de-para de execução:

```rb
watch(%r(^spec/.+_spec\.rb$))
```

Utilizamos [regex](http://en.wikipedia.org/wiki/Regular_expression "Regular Expression") para dizer que se qualquer arquivo que termine com **_spec.rb**  que esteja dentro da pasta **spec** for alterado o comando `rspec` será executado para este próprio arquivo. Alterações no arquivo *spec/article/validations_spec.rb* executaria o comando:

```sh
rspec spec/article/validations_spec.rb --drb --color --format doc
```

Podemos também rodar alguma classe de teste específica quando algum arquivo for alterado, não ficando preso na execução da própria classe de teste alterada:

```rb
watch(%r(^app/models/(.+)\.rb$)) { |m| "spec/features/#{m[1]}" }
```

Aqui qualquer arquivo alterado que termine com **.rb** e esteja dentro da pasta **app/models** irá rodar sua respectiva specs. O nome do arquivo alterado é capturado pelo grupo (.+) que é passado para o bloco na variável `m`, logo "app/models/(article).rb" executará todos os arquivo da pasta "spec/models/(article)". (:

Mas se quisermos rodar toda a bateria de teste podemos fazer assim:

```rb
watch('spec/spec_helper.rb') { 'spec' }
```

### DRb

Com todas as regras do Guard configuradas, vamos configurar o que será carregado no servidor DRb uma única vez (prefork) e o que terá que ser executado antes de cada bateria de teste (each_run). Estas duas características são definidas pelo conteúdo dos em parenteses. Na maioria das vezes podemos colocar todo o conteúdo spec_helper no block `prefork` para ser executado uma única vez.

Vamos utilizar o Bootstrap do Spork para gerar as devidas configurações para gente:

```sh
spork --bootstrap
```

Agora vamos editar o *spec_helper.rb* e passar todo conteúdo exemplo que será carregado uma única vez para dentro do bloco **prefork**:

```rb
require 'rubygems'
require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'

  require File.expand_path('../../config/environment', __FILE__)
  require 'capybara/rails'
  require 'database_cleaner'
  require 'rspec/rails'

  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

  RSpec.configure do |config|
    config.after { DatabaseCleaner.clean }
  end
end

Spork.each_run do
end
```

Os dois primeiros requires deve ficar fora dos blocos e estamos com o Spork configurado e pronto para ser testado, mas antes vamos ver qual o tempo atual dos nossos testes:

```sh
time rspec

# Finished in 47.03 seconds
# 569 examples, 0 failures, 54 pending

# real  0m51.477s
# user 0m44.510s
# sys  0m2.912s
```

Agora vamos subir o Spork executando:

```sh
spork

# Using RSpec
# Preloading Rails environment
# Loading Spork.prefork block...
# Spork is ready and listening on 8989!
```

Sim, a aba do seu terminal ficará presa e o Spork ficará rodando na porta 8989. Repare que é digo que o block `prefork` foi carregado com sucesso. Então iremos abrir outra aba e executar novamente os testes, mas destava vez aproveitando o load do DRb utilizando o parâmetro `--drb`:

```sh
time rspec spec --drb

# Finished in 46.09 seconds
# 569 examples, 0 failures, 54 pending

# real  0m50.093s
# user 0m1.387s
# sys 0m0.187s
```

Veja que o tempo real da execução dos testes deste blog [github.com/wbotelhos/wbotelhos-com-br](http://github.com/wbotelhos/wbotelhos-com-br "Blog") não teve tanta diferença, pois não carrego tanta coisa no boot do mesmo, mas mesmo assim vemos a diferença do uso do CPU no processo do usuário e do kernel abaixando.

Em um dos projetos que compoe o CMS do [R7.com](http://r7.com "R7.com") que também depende de carregar vários outros pequenos projetos, o tempo caiu de `1:47` para `0:24` em uma bateria de quase 500 teste, ou seja, mais de um minuto era apenas para carregar as dependências. E esperar tudo isso, mesmo que rodemos uma única classe de teste é um grande desperdício de tempo.

### Auto Teste

Além de toda essa otimização podemos ter o conforto de deixar o Guard rodar os testes de acordo com a nossa configuração no Guardfile. Precisamos de uma API para notificar o Guard que algum arquivo foi alterado e ele possa executar os eventos, e esta API varia de SO para SO:

OS X: [rb-fsevent](https://github.com/thibaudgg/rb-fsevent "FSEvents API")
Linux: [rb-inotify](https://github.com/nex3/rb-inotify "Inotify")
Windows: [rb-fchange](https://github.com/stereobooster/rb-fchange "RB FChange")

Utilizo Linux no trabalho e OS X em casa, mas se você alterna de ambiente muito dinâmicamente, você pode declarar as gems dos SOs que você utiliza que a apropriada será carregada corretamente.

> Faça isso caso as coisas no seu serviço aconteçam muito rápidas. INTERNA, piada (risos)

**Linux**

```rb
group :development do
  gem 'rb-inotify', '~> 0.9.0', require: false
end
```

**OS X**

```rb
group :development do
  gem 'rb-fsevent', '~> 0.9.3', require: false
end
```

Agora instale as gems:

```sh
bundle install
```

### Increasing the amount of inotify watchers

O inotify tem um limite de arquivos que o mesmo consegue monitorar, porém podemos aumentar esse limite com o seguinte comando:

```sh
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

### Guard console

Agora vamos subir o guard para ativar os nossos observadores:

```sh
guard

# 23:31:13 - INFO - Guard uses TerminalTitle to send notifications.
# 23:31:13 - INFO - Starting Spork for RSpec
# Using RSpec
# Preloading Rails environment
# Loading Spork.prefork block...
# Spork is ready and listening on 8989!
# 23:31:16 - INFO - Spork server for RSpec successfully started

# 23:31:16 - INFO - Guard::RSpec is running
# 23:31:16 - INFO - Guard is now watching at '/Users/wbotelhos/workspace/wbotelhos-com-br'
# [1] guard(main)>
```

Veja que o Guard subiu o Spork e já esta observando o projeto. Logo se alterarmos alguma classe o Guardfile será lido e de acordo com o de-para que fizemos os testes serão executados.

O console disponibilizado possui vários comandos e aceita algumas letras seguida de *enter* para executar comandos:

`a`: (all) Roda todos os testes.
`r`: (reload) Faz o reload do Spork.
`p`: (pause) Pausa e despausa o listening.
`q` ou `e`: (quit / exit) Finaliza o console.
`s`: (status) Mostra toda a configuração do Guardfile.

Para conhecer outros comandos execute:

`h`: Help.

### Cache

Um caso muito comum de acontecer é a não execução do Guard quando uma classe é alterada. Depois de algumas pesquisas o desenvolvedor constata que é problema de cache. Para resolver podemos fazer o reload das classes desejadas no bloco `each_run`:

```rb
Dir[Rails.root + 'app/**/*.rb'].each { |file| load file }
```

E pra quem utiliza a gem [FactoryGirl](https://github.com/thoughtbot/factory_girl "Factory Girl"), chamar o método `reload` para recarregar as factories:

```rb
FactoryGirl.reload
```

Outro problema também é o cache setado no arquivo *config/environments/test.rb*. Quando o Spork sobe o DRb ele seta uma variável de ambiente chamada **DRB** com o valor `'true'`, baseado nesse valor ativamos ou não o cache no ambiente de teste:

```rb
config.cache_classes = ENV['DRB'] != 'true'
```

Assim só iremos utilizar o cache se o Spork não estiver rodando. (:

### Isolamento de teste

A primeira coisa que você irá perceber e se assustar é que ao alterarmos apenas uma linha de código todo o arquivo de teste mapeado para tal classe será executado. E se tivermos umas quantidade grande de testes, todos serão executados, mas as vezes queremos executar apenas um pequeno contexto. Para isso podemos utilizar a opção de filtro onde focamos o RSpec apenas em alguns testes. No *spec_helper.rb* adicione o seguinte block de código:

```rb
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
```

No primeiro comando habilitamos o uso de meta-dados nos blocos de testes, ou seja, podemos adicionar parâmetros que poderão fazer parte do bloco de teste:

```rb
it 'use metadata', some: 'metadata' do
  ...
end
```

Com isso habilitado podemos fazer um filtro de qual teste o Guard irá rodar baseado em um meta-dado de nossa escolha, que no caso será o símbolo `:focus`, ficando assim:

```rb
it 'run isolated', :focus do
  ...
end
```

O próprio símbole é considerado `true`, logo o Guard irá rodar apenas os testes que tiverem este meta-dado. E se não tivermos nenhum `:focus` na classe de teste? Bem, ai nenhum teste será executado, e é ai que entra a última configuração que diz que se não for encontrado nenhum meta-dado, todos os testes serão executados.

### Notification

Repare que na primeira linha do output do comando `guard` é dito "Guard uses TerminalTitle to send notifications.", isso porque não temos nenhum API configurada para notificar as ações do Guard, logo isto será apenas escrito na aba do terminal, o que já é legal. Para termos uma pop up bonitinha, vamos utilizar a gem [ruby_gntp](https://github.com/snaka/ruby_gntp "Ruby GNTP"):

```sh
group :development do
  gem 'ruby_gntp', '~> 0.3.4'
end
```

Temos diversas outras gems para notificação, cada uma com suas restrições e features. Eu decidi utilizar a citada acima, por ser suportada tanto no Linux quando no OS X e utilizar o protocólo do [Growl](http://growl.info "Growl") que curto bastante. Para o Linux ele é grátis, para o Mac custa [$3.99](https://itunes.apple.com/us/app/growl/id467939042?mt=12&ign-mpt=uo%3D4 "Comprar o Growl").

Temos outras gems para o OS X, mas em sua maioria depende do Growl:

[growl](https://rubygems.org/gems/growl "Growl"): A gem original do Growl que além de ser paga necessita de instalação do [growlnotify](http://growl.info/downloads "GrowlNotify"), um pequeno .dpkg;
[terminal-notifier-guard](https://github.com/Springest/terminal-notifier-guard "Terminal Notifier Guard"): Não depende do Growl, mas só é compatível com o **OS X 10.8**. Se você não pagou o Growl, terá que pagar o SO.
[growl_notify](https://rubygems.org/gems/growl_notify "Growl Notify"): Usa o Growl e não terá suporte de notificação utilizando o Spork, ou seja, néca né?.

O suporte para Windows vou ignorar achando que você esta brincando e é isso ai, agora é partir para os testes. (;
