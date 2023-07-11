---
date: 2012-10-31T00:00:00-03:00
description: "Iniciando Com Testes JavaScript Usando Jasmine"
tags: ["javascript", "jasmine", "teste", "unidade"]
title: "Iniciando Com Testes JavaScript Usando Jasmine"
---

Cada dia mais as boas práticas na criação de testes estão crescendo. Temos ferramentas de testes para quase todas as linguagens. Já falei um pouco sobre [Testes em Ruby](http://wbotelhos.com/iniciando-com-testes-de-unidade-e-funcionais-usando-rspec) e hoje atacaremos os testes no frontend: testes de [JavaScript](http://pt.wikipedia.org/wiki/JavaScript).

# Objetivo

Criar um projeto com a estrutura necessária para execução de testes JavaScript com o [Jasmine](http://jasmine.github.io) e fazer uma breve introdução de uso.


# Criando o Projeto

Vamos criar um projetinho exemplo com os seguintes comandos:

```sh
cd ~/workspace

mkdir -p iniciando-com-testes-javascript-usando-jasmine/spec/lib
cd iniciando-com-testes-javascript-usando-jasmine/spec

wget https://github.com/pivotal/jasmine/archive/v2.0.2.zip
unzip v2.0.2.zip
rm v2.0.2.zip

cp jasmine-2.0.2/lib/jasmine-core/boot.js lib
cp jasmine-2.0.2/lib/jasmine-core/jasmine-html.js lib
cp jasmine-2.0.2/lib/jasmine-core/jasmine.css lib
cp jasmine-2.0.2/lib/jasmine-core/jasmine.js lib

rm -r jasmine-2.0.2
```

Pronto, já temos tudo que precisamos da biblioteca do Jasmine:

boot.js: Inicia o jasmine.
jasmine-html.js: Monta a view de resultado.
jasmine.css: Estiliza a view de resultado.
jasmine.js: O core do Jasmine com todo os asserts e afins.

Vamos criar agora uma página (run.html) que importará todos esses arquivos + o assets a serem testados + os arquivos que conterão os testes:

```js
touch run.html
```

Com o seguinte conteúdo:

```html
<!DOCTYPE html>

<html>
<head>
  <meta charset="utf-8">
  <title>http://wbotelhos.com/iniciando-com-testes-javascript-usando-jasmine</title>

  <!-- jasmine -->
  <link rel="stylesheet" href="lib/jasmine.css">

  <script src="lib/jasmine.js"></script>
  <script src="lib/jasmine-html.js"></script>
  <script src="lib/boot.js"></script>

  <!-- assets -->
  <script src="../app/assets/javascripts/chat.js"></script>

  <!-- specs -->
  <script src="chat_spec.js"></script>
</head>
<body></body>
</html>
```

Veja que o arquivo a ser testado é o `chat.js`. Vamos criá-lo:

```sh
mkdir -p ../app/assets/javascripts
touch ../app/assets/javascripts/chat.js
```

Com o seguinte contéudo:

```js
function Chat(nickname) {
  'use strict';

  this.nickname = nickname;
}

Chat.prototype.talk = function(message) {
  'use strict';

  return this.nickname + ' said: ' + message;
};
```

Antes de criamos os nossos primeiros testes, vamos analisar as lógicas contidas nele:

1 Construtor
1.1 O `nickname` é guardado na instancia do objeto.

2 Método `talk`
2.1 Recebe um mensagem.
2.2 Prefixa a mensagem com o `nickname` mais o texto ` said: `.

Agora vamos criar a classe de teste:

```sh
touch chat_spec.js
```

Com os seguinte conteúdo:

```js
describe('#constructor', function() {

});
```

O método `describe` serve para organizarmos os nossos testes. Este método recebe um primeiro parâmetro de texto como descrição do que estamos testando, nesse caso, o construtor. E um segundo como uma função anônima contendo o código de teste que pode ter mais `describe` or não.

Esse primeiro bloco não executa nada, apenas entra como um organizador de idéias. O que é levado como o caso de teste em si é a função `it` que pode ir dentro deste `describe`:

```js
// ...
  it ('keeps the nickname on instance', function() {

  });
// ...
```

Diferente do `describe`, no `it` escrevemos o que o código que esta sendo testado deve fazer e dentro deste block tentamos simular isso:

1. Vamos criar o objeto chat passando um nickname para ele:

```js
// ...
  var chat = new Chat('jasmine');
// ...
```

2. Vamos verificar se o objeto mantém o nickname passado. Algo como `chat.nickname deve existir`.

Para fazermos uma verificação utilizamos o método `expect` com o conteúdo que estamos verificando. Neste caso o "existir" é o mesmo que o atributo `nickname` não ser indefinido (`undefined`). Para isso podemos usar o seguinte código:

```js
describe('#constructor', function() {
  it ('keeps the nickname on instance', function() {
    var chat = new Chat('jasmine');

    expect(chat.nickname).not.toBeUndefined();
  });
});
```

Veja que o `chat.nickname` esta sendo passado para o `expect`, pois este attributo que esta sendo verificado no momento. Logo em seguida usamos o método `toBeUndefined` que afirma que algo é `undefined`, porém queremos o contrário, que seja definido; por isso negamos a sentança com um `.not` no início.

Para testarmos esse código, basta abrirmos o arquivo `run.html` para que o testes seja executado:

```sh
open run.html
```

```html
#constructor
    keeps the nickname on instance
```

Podemos verificar mais do que apenas se o valor existe, mas também podemos saber qual valor esta atribuido em tal variável. Basta usarmos o `toEqual`:

```js
it ('keeps the nickname on instance', function() {
  var chat = new Chat('jasmine');

  expect(chat.nickname).toEqual('jasmine');
});
```

Pronto, estamos com os nossos testes passando e um estrutura pronta para testar o nosso código JavaScript. O Jasmine tem vários outros [Matchers](https://github.com/pivotal/jasmine/wiki/Matchers) que podem ser explorados.

Falaremos mais sobre nos próximos artigos. Abraço.

Veja esse projeto no Github: [https://github.com/wbotelhos/iniciando-com-testes-javascript-usando-jasmine](https://github.com/wbotelhos/iniciando-com-testes-javascript-usando-jasmine)
