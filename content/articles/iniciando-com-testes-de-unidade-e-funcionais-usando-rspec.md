---
date: 2012-06-07T00:00:00-03:00
description: "Iniciando Com Testes de Unidade e Funcionais Usando RSpec"
tags: ["ruby", "rspec", "teste", "unidade"]
title: "Iniciando Com Testes de Unidade e Funcionais Usando RSpec"
---

Dando continuidade ao primeiro artigo [Iniciando com Testes Ruby Usando RSpec](http://wbotelhos.com/iniciando-com-testes-ruby-usando-rspec), vamos nos aprofundar um pouco mais neste mundo de teste e entender dois tipos mais comuns, os de [Unidade](http://en.wikipedia.org/wiki/Unit_testing) e os [Funcionais](http://en.wikipedia.org/wiki/Functional_testing).

# Objetivo

Mostrar como criar testes de unidade e testes funcionais utilizando o [RSpec](http://rspec.info).

# Testes de Unidade

São testes pontuais, onde testamos apenas uma porção do código como, por exemplo, um simples método no qual verifica se há uma determinada palavra em um texto. Para exemplificarmos melhor, baixe o projeto do primeiro artigo, [https://github.com/wbotelhos/iniciando-com-testes-ruby-usando-rspec](https://github.com/wbotelhos/iniciando-com-testes-ruby-usando-rspec), e veja que o teste `#language` do arquivo `article_spec.rb` é um teste de unidade, já que testa apenas um pequeno método com uma única lógica de detectar palavras em uma frase:

```ruby
describe '#language' do
  context 'when title is about Ruby' do
    it 'returns "Ruby"' do
      expect(described_class.language('Aprendendo Ruby')).to eq 'Ruby'
    end
  end
end
```

Vamos evoluir a nossa aplicação e adicionar alguns campos em nosso modelo com a seguinte migration `db/migrate/20140101000001_create_articles.rb`:

```ruby
class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.string   :slug
      t.string   :title
      t.text     :body

      t.timestamps
    end
  end

  def down
    drop_table :articles
  end
end
```

E dizer que este modelo é persistível via [ActiveRecord](http://pt.wikipedia.org/wiki/Active_record) adicionando a herança:

```ruby
class Article < ActiveRecord::Base
```
E então aplicar essa migração:

```ruby
# Remove as bases de dev, test e prod
rake db:drop:all

# Cria as bases de dev, test e prod
rake db:create:all

# Cria o schema do banco de acordo com as migrations
rake db:migrate

# Aplica as alterações no banco de teste
rake db:test:prepare
```

## Requisitos do cliente

"Ao salvar o artigo, quero que seja criado um *slug* para ser a URL."

Para isso iremos usar [TDD](http://pt.wikipedia.org/wiki/Test_Driven_Development) para pensarmos no resultado antes de pensar em como implementar a melhor lógica. Teremos os seguintes casos:

- Se o título tiver espaço, o espaço será substituido por hífen;

```ruby
it 'replaces the space' do
  expect(described_class.slug('a b')).to eq 'a-b'
end
```

- Se o título tiver letras maiúsculas, será substituidas por letras minúsculas.

```ruby
it 'downcases all words' do
  expect(described_class.slug('AB')).to eq ('ab')
end
```

Ao rodarmos esses testes receberemos o erro `undefined method 'slug' for Article:Class`, porque ainda não temos o método `slug`. Então vamos cría-lo:

```ruby
def self.slug(text)
  text.gsub /\s/, '-'
end
```

Rodando novamente, fizemos um teste passar, mas ainda não esta deixando tudo em letras minúsculas. Atualizando o método para o a seguir, teremos sucesso:

```ruby
def self.slug(text)
  text.downcase.gsub /\s/, '-'
end
```

*Baby Steps*! Nossos testes de unidades estão escritos e pasando. Estes devem ser o mais simples possível. Podemos dizer que **o teste de unidade certifica que o código faz o que o programador quer que ele faça**.

# Teste Funcional

São diferentes dos de unidade, **certificam que o programador esta fazendo o que o cliente deseja**. No teste de unidade escrito há pouco, garantimos que o método esta correto, mas não que ao salvar o artigo teremos todo o fluxo e resultado correto.

Vamos criar o *controller* do artigo com os métodos de salvar e listar:

```ruby
class ArticlesController < ApplicationController
  def create
    @article = Article.new article_params

    if @article.save
      redirect_to articles_url, notice: 'Artigo salvo com sucesso!'
    else
      flash.notice = 'Erro ao salvar o artigo.'
      render :new
    end
  end

  def index
    @articles = Article.all
  end
end
```

E as duas páginas usadas por estes métodos:

```bash
mkdir -p app/views/articles
touch app/views/articles/index.html.erb
touch app/views/articles/new.html.erb
```

E por fim as rotas:

```ruby
IniciandoComTestesDeUnidadeEFuncionaisUsandoRSpec::Application.routes.draw do
  resources :articles
end
```

Os testes funcionais normalmente ocorrem no *controller*, pois é lá que especificamos as ações do usuário como, por exemplo, um [CRUD](http://pt.wikipedia.org/wiki/CRUD).

### Listagem de artigos

Para este método temos os seguintes requisitos:

- Seja executado sem erros;

```ruby
it 'executes successfully' do
  get :index
  expect(response).to be_successful
end
```

Para simular o acesso a este método que se chama `index` usamos o verbo `get`. Então esperamos que a resposta seja feita com sucesso `be_successful`.

- Garantir que este método nos mande para a página correta.

```ruby
it 'renders the index article page' do
  get :index
  expect(response).to render_template 'articles/index'
end
```

Como não alteramos o comportamente padrão, a página terá o mesmo nome que o método e estará dentro da pasta com o mesmo nome do *controller*. Então usamos `render_template` para dizer que a página `index` dentro da pasta `articles` será renderizada.

### Criação do artigo

Para este método temos mais requisitos. Pensando no caminho feliz temos:

- O artigo é salvo com sucesso;

```ruby
it 'creates a new article' do
  expect {
    post :create, article: { title: 'The Title' }
description: 'The Title' }
  }.to change(Article, :count).by 1
end
```

Após executarmos o comando de salvar o artigo, experamos que a contagem `:count` do `Article` seja alterada `change` em uma unidade `by 1`.

- Somos redirecionados para a listagem de artigos;

```ruby
it 'redirects to listing page' do
  post :create, article: { title: 'The Title' }
description: 'The Title' }
  expect(response).to redirect_to articles_url
end
```

A rota `articles_url` nos manda para o método `index`, que é a listagem.

- É enviado uma mensagem de sucesso para a tela.

```ruby
it 'shows success message' do
  post :create, article: { title: 'The Title' }
description: 'The Title' }
  expect(flash.notice).to eq 'Artigo salvo com sucesso!'
end
```

A mensagem de sucesso, contida na variável `notice` tem a descrição correta.

Para fazermos o caminho triste, precisamos ter uma regra para levá-la a falha. Vamos dizer que o título do artigo seja obrigatório:

```ruby
class Article < ActiveRecord::Base
  validates :title , presence: true
```

Então para o caminho triste, com o campo `title` nulo, temos:

- Não é criado um artigo novo;

```ruby
it 'does not save the record' do
  expect {
    post :create, article: { title: nil }
description: nil }
  }.to_not change Article, :count
end
```

Ao salvar o artigo, não há alterações na contagem dos artigos, logo negamos o `to` para `to_not`.

- A página do formulário de criação do artigo é re-renderizada;

```ruby
it 're-renders the new page' do
  post :create, article: { title: nil }
description: nil }

  expect(response).to render_template 'articles/new'
end
```

- A mensagem de erro contida na variável `notice` é descrita corretamente.

```ruby
it 'shows flash message' do
  post :create, article: { title: nil }
description: nil }
  expect(flash.notice).to eq 'Erro ao salvar o artigo.'
end
```

Green! Nosso projeto já tem uns bons testes, agora é manter e dar manutenção nos mesmos. Claro que ainda temos vários casos a cobrir como, por exemplo, verificar se o *slug* foi gerado corretamente. Mas isso ficará como dever de casa pra vocês.

Assim como o nosso código de produção, os testes são códigos vivos e devem ser mantidos, evoluidos e refatorados. Se você faz TDD ou não, não importa, o importante é testar o que foi criado para que se tenha um *feedback* rápido e um *deploy* mais seguro.

Veja esse projeto no Github: [https://github.com/wbotelhos/iniciando-com-testes-de-unidade-e-funcionais-usando-rspec](https://github.com/wbotelhos/iniciando-com-testes-de-unidade-e-funcionais-usando-rspec)
