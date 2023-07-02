---
date: 2012-03-05T00:00:00-03:00
description: "Criando Templates SASS Com Function Nth e Index"
tags: ["sass", "template", "nth", "index"]
title: "Criando Templates SASS Com Function Nth e Index"
---

Pra quem trabalha com *front end*, sabe que a tarefa de criar folhas de estilos bem estruturadas e sem muitas repetições não é um trabalho simples. A tarefa fica mais difícil ainda quando precisamos criar diversos layouts onde cada página tem sua própria identidade visual, já que com o passar do tempo teremos mais e mais páginas.

Com a evolução do CSS veio algums linguagens que nos ajudam a escrever menos código e gerar mais conteúdo como o **SCSS** e o [SASS](http://en.wikipedia.org/wiki/Sass_(stylesheet_language)), abordado nesse artigo.

## Objetivo

Criar um esquema de template onde poderemos especificar as propriedades dinâmicas de forma fácil sem precisar reescrever todo o restante dos estilos.

## Código base

Iremos trabalhar com 4 estruturas de código HTML identicas, porém cada uma dessas estruturas terá um *stylesheet* diferente. Cada estrutura contêm 3 itens: Github, Linkedin e Twitter que deverá ser estilizados utilizando as funções descrita acima de cada um deste:


```html
<h2>none</h2>

<div class="none">
  <div class="github">http://github.com/wbotelhos</div>
  <div class="linkedin">http://linkedin.com/in/wbotelhos</div>
  <div class="twitter">http://twitter.com/wbotelhos</div>
</div>

<h2>each + nth</h2>

<div class="each-nth">
  <div class="github">http://github.com/wbotelhos</div>
  <div class="linkedin">http://linkedin.com/in/wbotelhos</div>
  <div class="twitter">http://twitter.com/wbotelhos</div>
</div>

<h2>each + nth + function</h2>

<div class="each-nth-function">
  <div class="github">http://github.com/wbotelhos</div>
  <div class="linkedin">http://linkedin.com/in/wbotelhos</div>
  <div class="twitter">http://twitter.com/wbotelhos</div>
</div>

<h2>each + nth + function + index</h2>

<div class="each-nth-function-index">
  <div class="github">http://github.com/wbotelhos</div>
  <div class="linkedin">http://linkedin.com/in/wbotelhos</div>
  <div class="twitter">http://twitter.com/wbotelhos</div>
</div>
```

Repare que para cada item temos descrito quais funções iremos utilizar para gerar o estilo.

Cada um desses items possuem propriedades específicas, assim como propriedades exclusivas. Iremos evoluir o primeiro estilo **none**, sendo que este já esta estilizado, veja:

```sass
.none
  .github
    background-color: #333
    color: #FFF
    height: 40px
    padding-top: 20px
    text-align: center

  .linkedin
    background-color: #1B86BC
    color: #EEE
    height: 40px
    padding-top: 20px
    text-align: center

  .twitter
    background-color: #00ABF0
    color: #DDD
    height: 40px
    padding-top: 20px
    text-align: center
```

O resultado deverá ser sempre o mesmo:


<style>
.none .github {
  background-color: #333;
  color: #FFF;
  height: 40px;
  padding-top: 10px;
  text-align: center
}

.none .linkedin {
  background-color: #1B86BC;
  color: #EEE;
  height: 40px;
  padding-top: 10px;
  text-align: center
}

.none .twitter {
  background-color: #00ABF0;
  color: #FFF;
  height: 40px;
  padding-top: 10px;
  text-align: center
}
</style>

<div class="none">
  <div class="github">http://github.com/wbotelhos</div>
  <div class="linkedin">http://linkedin.com/in/wbotelhos</div>
  <div class="twitter">http://twitter.com/wbotelhos</div>
</div>

## Análise

Podemos ver que há um padrão:

`height`, `padding-top` e `text-align` são iguais para todos.
`background-color` e `color` cada um tem o seu.

## Utilizando as funções each e nth

Vamos criar um outro arquivo `each-nth.css.sass` para refatorarmos esse código utilizando principalmente as funções `each` e `nth` para nos ajudar.

Primeiramente iremos separar os valores utilizados em variáveis que sempre iniciam com um `$` no início.

### Variáveis

```sass
$default-height: 40px
$default-padding-top: 20px
$default-text-align: center

$github-background-color: #333
$github-color: #FFF

$linkedin-background-color: #1B86BC
$linkedin-color: #EEE

$twitter-background-color: #00ABF0
$twitter-color: #DDD
```

Até aqui nada demais. Criamos as propriedades default com o prefix `default_` seguido do nome da propriedade e também criamos as cores do texto e do *background* para cada uma das redes sociais, então para o github temos o prefixo `github_` seguido da propriedade e assim por diante.

### Array de dados

Para declaramos um array é bem fácil, só se diferencia de todas as linguagens do mundo por não precisamors dos parenteses envolvendo os valores, então seria assim:

```sass
$variavel: item1, item2, item3
```

E da mesma forma podemos ter array de array com a diferença de que os arrays internos não são separados por vírgula, mas sim por espaço em branco, ficando algo como:

```sass
$variavel: item1-1 item1-2 item1-3, item2-1 item2-2 item2-3, item3-1 item3-2 item3-3
```

Mas por que isso é importante pra gente? Bem, se temos um array, também temos uma função para iterá-los, logo podemos colocar nesse array todos os nomes de classe que iremos utilizar em nosso css. E melhor ainda, podemos já declarar todas as propriedades que iremos utilizar para cada um das classes, veja:

```sass
$skins: github $github_background-color $github_color, linkedin $linkedin_background-color $linkedin_color, twitter $twitter_background-color $twitter_color
```

O nome dessa variável nossa será `$skins` e cada item do array será um template. Em cada um desse template temos um outro array de dados onde a primeira posição é o nome do template, como `github`, por exemplo, e as outras posições são as propriedades. Os arrays do SASS começam com o índice 1, logo temos:

$skins[1]: template do github
$skins[2]: template do linkedin
$skins[3]: template do twitter

$skins[x][1]: nome do template
$skins[x][2]: cor do background
$skins[x][3]: cor do texto

> Ok, respira! SASS não é para fazer somente coisas básicas como usar seu neste> dy e remover chaves e ponto-e-vírgulas. A estrutura dá um trabalhinho, mas o resultado é ótima, aguarde! (:

Com tudo dentro da variável `$skins`, vamos utilizar a função `@each` para iterar os dados com a mesma sintáxe do Ruby, JavaScript e afins:

```sass
@each $skin in $skins
  // utilizar a variável $skin aqui
```

A primeira coisa que queremos aqui é o nome de nossas classes, porém cada valor `$skin` contêm um array de três itens, ou seja, para cada `$skin` temos que pegar um posição específica. Para recuperarmos o índice de um array podemos utilizar a função `nth(array, indice)`. Então para pegarmos o nome do nosso template que esta na posição **1** faríamos:

```sass
@each $skin in $skins
  nth($skin, 1) // posição 1 do array da iteração == 'github'
```

Mas como queremos esse nome como um seletor *class*, temos que concatenar um ponto com o nome do template. Para fazer essa concatenação, temos que interpolar os dados, assim como utilizamos no Ruby:

```sass
@each $skin in $skins
  .#{nth($skin, 1)} // .github, .linkedin, .twitter
```

Assim teremos:

```css
.github {}
.linkedin {}
.twitter {}
```

Logo podemos já escrever as propriedades comuns a todos os template:


```sass
@each $skin in $skins
  .#{nth($skin, 1)}
    height: $default-height
    padding-top: $default-padding-top
    text-align: $default-text-align
```

Resultando em:

```css
.github {
  height: 40px
  padding-top: 20px
  text-align: center
}

.linkedin {
  height: 40px
  padding-top: 20px
  text-align: center
}

.twitter {
  height: 40px
  padding-top: 20px
  text-align: center
}
```

Cool! E as propriedades dinâmicas? Bem, elas estão nos arrays internos e assim como pegamos o nome do template na posição 1, podemos pegar a cor de *background* na posição 2 e a cor de texto na posição 3.

```sass
@each $skin in $skins
  .#{nth($skin, 1)}
    background-color: nth($skin, 2)
    color: nth($skin, 3)
    height: $default-height
    padding-top: $default-padding-top
    text-align: $default-text-align
```

Repare que não utilizamos interpolação nos outros itens, pois o valor não precisa de ser concatenado a nada, há um espaço entre os dois pontos e o valor.

Assim temos o nosso resultado final do primeiro refactor:

```css
.github {
  background-color: #333
  color: #EEE
  height: 40px
  padding-top: 20px
  text-align: center
}

.linkedin {
  background-color: #1B86BC
  color: #DDD
  height: 40px
  padding-top: 20px
  text-align: center
}

.twitter {
  background-color: #00ABF0
  color: #CCC
  height: 40px
  padding-top: 20px
  text-align: center
}
```

### Código do refactor 1

```sass
$default-height: 40px
$default-padding-top: 20px
$default-text-align: center

$github-background-color: #333
$github-color: #FFF

$linkedin-background-color: #1B86BC
$linkedin-color: #EEE

$twitter-background-color: #00ABF0
$twitter-color: #DDD

$skins: github $github-background-color $github-color, linkedin $linkedin-background-color $linkedin-color, twitter $twitter-background-color $twitter-color

@each $skin in $skins
  .#{nth($skin, 1)}
    background-color: nth($skin, 2)
    color: nth($skin, 3)
    height: $default-height
    padding-top: $default-padding-top
    text-align: $default-text-align
```

### Vantagens

1. Não precisamos repetir o bloco de cada template (class), pois o `@each` já irá montar;
2. Não repetimos as propriedades estáticas, pois elas são referenciadas via variáveis;
3. Ao mudar os valores estáticos, mudamos automáticamente para todos os templates;
4. Para mudarmos os valores dinâmicos, basta alterar os valores das variáveis de cada template.

### Desvantagens

1. As declarações de variáveis são poluidas, temos o prefixo e o nome da propriedade para cada template;
2. Para cada valor dinâmico adicionado temos que adicionar tal item no array interno das skins, onde se esquecermos um item ou adicionarmos um a mais em alguns desses arrays internos, teremos um erro de índice;
3. A forma de escrita do array de array vai ficando cada vez mais complexo, pois deve ser escrito sempre em uma única linha;
4. Para recuperarmos os valores dinâmicos somos obrigados a decorar sua posição e para quem esta lendo `nth($skin, 2)` não significa nada.


## Utilizando as funções each, nth e function

Com a ajuda da função `@function` podemos resolver a desvantagem 4, pois podemos isolar os valores dinâmicos em methodos com nomes de fácil relação. A forma de declarar uma função é semelhante ao do JavaScript, e como qualquer função podemos retornar valores utilizando `@return`:

```sass
@function foo_bar($foo, $bar)
  @return $foo
```

> Um curiosidade é que o SASS não diferencia `_` de `-`, então se você escrever sua variável `foo-bar` você pode chamar por `foo_bar` que irá funcionar. Porém prefiro usar o padrão: métodos com underline e variáveis com hífen.

Agora podemos resolver o item 4 dando nomes para cada um dos valores dinâmicos ficando:

```sass
@function class_name_for($skin)
  @return nth($skin, 1)

@function background_color_for($skin)
  @return nth($skin, 2)

@function color-for($skin)
  @return nth($skin, 3)
```

Agora ficou mais fácil, pois passamos a skin da iteração e recuperamos o valor:

```sass
@each $skin in $skins
  .#{class_name_for($skin)}
    background-color: background_color_for($skin)
    color: color-for($skin)
    height: $default-height
    padding-top: $default-padding-top
    text-align: $default-text-align
```

Veja, quem for dar manutenção não precisa saber qual a posição da cor do *background*, da cor do texto ou do nome do template, basta usar a função criada por quem deu manutenção no core do sistema de template.

### Código do refactor 2

```sass
$default-height: 40px
$default-padding-top: 20px
$default-text-align: center

$github-background-color: #333
$github-color: #EEE

$linkedin-background-color: #1B86BC
$linkedin-color: #DDD

$twitter-background-color: #00ABF0
$twitter-color: #CCC

$skins: github $github-background-color $github-color, linkedin $linkedin-background-color $linkedin-color, twitter $twitter-background-color $twitter-color

@function class_name_for($skin)
  @return nth($skin, 1)

@function background_color_for($skin)
  @return nth($skin, 2)

@function color-for($skin)
  @return nth($skin, 3)

@each $skin in $skins
  .#{class_name_for($skin)}
    background-color: background_color_for($skin)
    color: color-for($skin)
    height: $default-height
    padding-top: $default-padding-top
    text-align: $default-text-align
```

### Vantagens

1. Não precisamos repetir o bloco de cada template (class), pois o `@each` já irá montar;
2. Não repetimos as propriedades estáticas, pois elas são referenciadas via variáveis;
3. Ao mudar os valores estáticos, mudamos automáticamente para todos os templates;
4. Para mudarmos os valores dinâmicos, basta alterar os valores das variáveis de cada template;
5. Não precisamos decorar o índice de cada propriedade sempre, pois durante a manutenção do core do template já criamos uma função para abstrair isso.

### Desvantagens

1. As declarações de variáveis são poluidas, temos o prefixo e o nome da propriedade para cada template;
2. Para cada valor dinâmico adicionado temos que adicionar tal item no array interno das skins, onde se esquecermos um item ou adicionarmos um a mais em alguns desses arrays internos, teremos um erro de índice;
3. A forma de escrita do array de array vai ficando cada vez mais complexo, pois deve ser escrito sempre em uma única linha;
4. Ainda sim o desenvolvedor do core deve saber a posição de cada uma das variáveis durante a manutenção.

## Utilizando as funções each, nth, function e index

Se você reparar bem, até então estamos declarando as variáveis para serem jogadas em um array de array. Esse array de array pode ser facilmente traduzido por uma matriz:

```sass
$skins:              github    linkedin    twitter
$background-colors:  #333      #1B86BC     #00ABF0
$colors:             #EEE      #DDD        #CCC
```

Menos código, mais legível. Veja que ficamos com os arrays internos separados por variáveis basicamente. Resolvemos o problema 1, pois não repetimos as declarações prefixadas. Resolvemos o problema 2, pois fica bem claro as posições dos valores por ser uma matriz, um a mais ou um a menos será facilmente visível. Resolve o problema 3, pois a proporção de crescimento é pequena e cresce para dois lados (horizontal e vertical), não mais somente para um.

> Tanto faz separamos por vírgula ou por espaço os itens do array.

Agora nossa iteração $`skin in $skins` irá retorna apenas o nome da skin (github, linkedin e twitter) que por sua vez corresponde a posição (1, 2 e 3). Então se quisermos a `color` do linkedin (2) teremos `#DDD`, certo?

Com a função `index(array, value)` conseguimos recuperar qual a posição de determinado valor em um array e é com essa função que iremos pegar os valores correspondentes para cada skin. Desta forma resolvemos o problema número

```sass
@function index_for($skin)
  @return index($skins, $skin) // index(github linkedin twitter, linkedin) == 2
```

A função acima servirá como um ponteiro para pegarmos os valores na matriz, podemos usá-la da seguinte forma:

```sass
@function background_color_for($skin)
  @return nth($background-colors, index_for($skin)) // nth(#333 #1B86BC #00ABF0, 2) == #1B86BC
```

Como temos o número da coluna a buscar os dados graças ao método `index_for()`, basta dizermos em qual linha queremos pegar o valor, neste caso na linha das cores de fundo. Se quisermos pegar a cor, basta fazer a mesma coisa para tal linha:

```sass
@function color_for($skin)
  @return nth($colors, index_for($skin))
```

E por fim utilizar tais funções sem se preocupar com índices:


```sass
@each $skin in $skins
  .#{$skin}
    background-color: background_color_for($skin)
    color: color_for($skin)
    height: $default-height
    padding-top: $default-padding-top
    text-align: $default-text-align
```

Agora escrevemos o que desejamos: Quero um "background color para a skin linkedin", resolvendo o problema número 4.

### Código do refactor 3

```sass
$default-height: 40px
$default-padding-top: 20px
$default-text-align: center

$skins:              github    linkedin    twitter
$background-colors:  #333      #1B86BC     #00ABF0
$colors:             #EEE      #DDD        #CCC

@function index_for($skin)
  // returns the index of the passed name of item on matrix
  @return index($skins, $skin)

@function background_color_for($skin)
  @return nth($background-colors, index_for($skin))

@function color_for($skin)
  @return nth($colors, index_for($skin))

@each $skin in $skins
  .#{$skin}
    background-color: background_color_for($skin)
    color: color_for($skin)
    height: $default-height
    padding-top: $default-padding-top
    text-align: $default-text-align
```

### Vantagens

1. Não precisamos repetir o bloco de cada template (class), pois o `@each` já irá montar;
2. Não repetimos as propriedades estáticas, pois elas são referenciadas via variáveis;
3. Ao mudar os valores estáticos, mudamos automáticamente para todos os templates;
4. Para mudarmos os valores dinâmicos, basta alterar os valores na matriz que é bem fácil de visualizar;
5. Não precisamos decorar o índice de cada propriedade, isso já é feito automáticamente;
6. Com uma mesma função conseguimos recuperar diferentes valores dependendo da skin passada.

### Desvantagens

1. Conhece alguma? Comente e deixe a sua sugestão.

Lembre-se que criar um "core" do SASS é mais complicado, porém deve ser flexível o suficiente para abstrair operações para o restante da equipe utilizar.

Na experiência obtida até hoje utilizando SASS em um equipe rasoavelmente grande é que se você não seguir um padrão, terá muitos problemas e acabará caindo no mito do código mágico (extra) que o SASS gera. Criar uma estrutura forte e seguir um padrão como o do [SMACSS](http://smacss.com) é essencial.

Veja esse projeto no Github: [https://github.com/wbotelhos/criando-templates-sass-com-function-nth-e-index](https://github.com/wbotelhos/criando-templates-sass-com-function-nth-e-index)
