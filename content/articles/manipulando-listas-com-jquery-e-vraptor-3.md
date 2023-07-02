---
date: 2010-12-06T00:00:00-03:00
description: "Manipulando Listas com jQuery e VRaptor 3"
tags: ["java", "vraptor", "jquery"]
title: "Manipulando Listas com jQuery e VRaptor 3"
---

**Atualizado em 13 de Fevereiro de 2012.**

Constantemente manipulamos coleções de dados em nossas aplicações, seja em pequenas ou grandes quantidades. Sabemos muito bem que controlar itens de lista em nossas classes não é algo trivial, quem dirá em nossas views. Hoje iremos ver como o [VRaptor](http://vraptor.caelum.com.br) nos facilita a manipulação de listas entre view e controller, e como ele junto ao [jQuery](http://jquery.com) nos proporcionam uma manipulação dinâmica e flexível.

### Objetivo:

Fazer um cadastro de filme que contenha vários artistas que podem ser adicionados ou removidos usando o jQuery para criar a dinâmica de tela e o VRaptor para capturar e organizar os dados.

<a href="http://www.wbotelhos.com.br/wp-content/uploads/2010/12/manipulando-listas-com-jquery-e-vraptor-3-1.png" target="_blank">
  <img src="http://www.wbotelhos.com.br/wp-content/uploads/2010/12/manipulando-listas-com-jquery-e-vraptor-3-1-300x192.png" alt="Manipulando Listas Dinâmicamente" title="Manipulando Listas Dinâmicamente" width="300" height="192" class="align-center" />
</a>

### Criando os modelos:

Vamos criar a entidade `Filme` que contém uma coleção de `Artista`.

```java
public class Filme {

  private Long id;
  private String titulo;
  private Collection<Artista> artista;

  // getters e setters

}
```

```java
public class Artista {

  private Long id;
  private String nome;

  // getters e setters

}
```

Vimos que nosso filme possui uma coleção de artistas.

### Criando o controller:

Primeiramente vamos trabalhar da forma mais "simples" usando array para entendermos quais são as facilidades e benefícios da solução final. Desse modo precisaremos de um método que receba nosso filme e também um array de artistas. Ops, um array de artistas não terá como né? Pois como iremos enviar vários objetos instanciados para o controller?

Então vamos mandar somente os nomes dos artistas e lá no controller os criaremos de fato.

```java
@Post("/filme")
public void salvar(Filme filme, String[] artistaNome) {

  Collection<Artista> artistas = new ArrayList<Artista>();

  for (String nome : artistaNome) {
    Artista artista = new Artista();
    artista.setNome(nome);

    artistas.add(artista);
  }

  filme.setArtistas(artistas);

  filmeDao.salvar(filme);

  result.redirectTo(this).listagem();
}
```

Rodamos o array criando um artista com cada nome, então o colocamos na lista. Após criarmos todos os artistas nós os setamos no filme. Ufa!

### Criando a view:

Nossa view precisará do campo com o título do filme e vários campos com os nomes dos artistas.

```html
<input type="text" name="filme.titulo" value="Matrix" />

<input type="text" name="artistaNome" value="Neo" />
<input type="text" name="artistaNome" value="Smith" />
<input type="text" name="artistaNome" value="Trinity" />
```

Se submetermos esse formulário teríamos o filme Matrix com os artistas Neo, Smith e Trinity.

Um problema nessa solução é que se mandarmos um artista apenas, o VRaptor não entenderá que é um vetor com apenas uma posição e o mesmo ficará `null`, da mesma forma se não passarmos nenhum artista, é claro. Uma forma um tanto quanto feia seria adicionar dois campos `hidden` com um valor `dummy`, por exemplo, para termos sempre um vetor mesmo que não criemos nenhum artista, e então excluiríamos estes campos *fake* no controller antes de salvar.

Outro problema é que precisamos no mínimo dos IDs dos artista para edição e para o relacionamento das entidades, então teríamos de passar outro vetor de IDs e ainda garantir que o primeiro ID pertencerá ao primeiro artista e assim por diante. Mas essa solução já deu o que tinha que dar e se você usá-la irá tomar umas chineladas! :P

O VRaptor sabe injetar valores diretamente nos objetos, então podemos receber diretamente uma coleção de artistas como argumento da seguinte forma:

```java
public void salvar(Filme filme, Collection<Artista> artistas) { }
```

A primeira pergunta que vem a cabeça é: "posso passar vários valores `value="artistas"` que o VRaptor preenche a lista sozinho igual acontece com o vetor?". Não, devemos indicar em qual posição da lista o valor será injetado e ele cuidará do resto.

```html
<input type="text" name="artistas[0].nome" value="Neo" />
<input type="text" name="artistas[1].nome" value="Smith" />
<input type="text" name="artistas[2].nome" value="Trinity" />
```

"Hum.... mas se o VRaptor sabe injetar os valores direto nos objetos e o objeto `Filme` já possui uma lista de artistas, então..." Exato! Podemos simplificar mais ainda nosso método injetando os artistas diretamente no filme:

```html
<input type="text" name="filme.artistas[0].nome" value="Neo" />
<input type="text" name="filme.artistas[1].nome" value="Smith" />
<input type="text" name="filme.artistas[42].nome" value="Trinity" />
```

Veja que agora injetamos o nome do artista dentro de uma determinada posição da lista que por sua vez esta dentro do objeto filme, com isso podemos retirar o segundo argumento do nosso método `salvar` e usarmos somente o objeto `filme`. Ok, pode soltar aquele "Putz!". :D

> Perceba que o terceiro campo esta com o índice 42 para demonstrar que não é necessário seguir uma ordem. Só tome cuidado para não repetir o índice, senão a posição ficará nula.

Agora que já sabemos a melhor forma de trabalhar com listas, vamos partir para a criação da nossa tela dinâmica com ajuda do jQuery.

### Criando a tela de exibição:

Para apresentar uma lista de dados na view precisamos apenas da ajuda do `forEach` da [JSTL](http://java.sun.com/products/jsp/jstl/reference/docs/index.html).

```jsp
Título: ${filme.titulo}

Artistas:
<c:forEach items="${filme.artistas}" var="artista">
  - ${artista.nome}
</c:forEach>

<a href="${pageContext.request.contextPath}/filme/editar/${filme.id}">Editar</a>
```

Tendo o filme no `request`, apresentamos o título do filme de forma normal acessando o seu atributo `titulo`. Para mostrar os artistas, fazemos uma iteração através dos mesmos e dentro do `forEach` pegamos cada um e apresentamos seus dados.

### Criando a tela de cadastro/edição:

Vamos criar um formulário para enviar as informações do filme junto com as dos artistas.

```jsp
<form action="${pageContext.request.contextPath}/filme" method="post">
  <c:if test="${filme != null &amp;&amp; filme.id != null}">
    <input type="hidden" name="filme.id" value="${filme.id}" />
  </c:if>

  Título: <input type="text" name="filme.titulo" value="${filme.titulo}" />

  <fieldset id="artista-container">
    <img src="${pageContext.request.contextPath}/img/adicionar.png" onclick="adicionar();" />

    <c:forEach items="${filme.artistas}" var="artista" varStatus="status">
      <div class="artista">
        Nome:
        <input type="text" name="filme.artistas[${status.index}].nome" value="${item.nome}" />
        <input type="hidden" name="filme.artistas[${status.index}].id" value="${artista.id}" />

        <img src="${pageContext.request.contextPath}/img/remover.png" class="button-remover" />
      </div>
    </c:forEach>
  </fieldset>
</form>
```

**Linha 1**: o formulário submete os dados para o método que espera um `filme`.
**Linha 2-4**: mantemos um campo escondido para manter o ID do filme durante a edição.
**Linha 6**: o título do filme é enviado e injetado no atributo `titulo` do filme.
**Linha 8**: identificamos este container para o jQuery usar como área onde estará localizado os campos dos artistas.
**Linha 9**: botão que chama a função para criar os campos para o preenchimento do dados de um novo artista.
**Linha 11**: iteramos a lista de artistas que pode estar vindo para ser editada. Perceba que temos o atributo `varStatus` que representa o índice da iteração.
**Linha 12**: fizemos um container para cada artista e os identificamos com a classe `artista` que servirá para localização de todos os artistas contidos no container.
**Linha 14-15**: campos criados dinamicamente para suportar os dados do artista. Injetamos o nome e o ID (durante a edição) do artista diretamente na lista que esta no objeto `filme`. Perceba que em cada iteração usamos o índice do loop para marcarmos a posição que este artista entrará na lista. Se lembra?
**Linha 17**: botão para o artista correspondente e um nome de classe para identificar tal botão.

## Criando o script de manipulação com o jQuery:

Com nossa estrutura montada, só nos resta manipular os elementos. Teremos uma função que cria os campos do artista e uma que os removem.

<span style="text-decoration: underline;">Criando um artista</span>:

Como os campos serão sempre iguais, iremos começar criando um modelo dos elementos que precisamos para a criação de um artista:

```js
  var model =
  '<div class="artista">' +
    '<label>Nome:</label>' +
    '<input type="text" name="filme.artistas[0].nome" />' +

    '<img src="${pageContext.request.contextPath}/img/remover.png" class="button-remover" />' +
  '</div>';
```

A variável `model` mantem um clone dos dados que já possuímos para criação do artista durante a edição. Caso você sempre possua uma estrutura dessa na tela é possível reaproveitá-la através da função [jQuery.clone()](http://api.jquery.com/clone) modificando o necessário após o clone da mesma. Mas no nosso caso não teremos essa estrutura inicialmente na tela.

Com esse modelo de dados, podemos criar a função que faz a inserção do mesmo no DOM:

```js
function adicionar() {
  $('#artista-container').append(model);

  reorderIndexes();
```

Uma função bem simples que pega o valor da variável e concatena no final do container onde ficam os "artistas". Como temos uma ordem natural na lista dos artista e podemos tanto adicionar como remover um artista do início, do fim ou do meio, precisamos de garantir um reajuste no índice do name dos campos. Para isso criamos a função `reorderIndexes()` que será mostrada, já já.

<span style="text-decoration: underline;">Removendo um artista</span>:

```js
$('.button-remover').live('click', function() {
  $(this).parent().remove();

  reorderIndexes();
});
```

Aplicamos a função de remover o artista a todos elementos que tenham a classe `button-remover`, neste caso, todos os botões de remover. A função é acionada no `click`, que ao ser executada, apaga o container (artista-item) no qual o botão esta contido, removendo todos os dados do artista em questão do formulário.

> O uso da função live é fundamental, pois ela consegue aplicar o bind da função mesmo nos elementos criados dinamicamente no DOM.

<span style="text-decoration: underline;">Reordenando os índices</span>:

Mais fácil do que ficar calculando qual o próximo valor, é percorrer todos os artistas ao mesmo tempo em que iremos aplicando o índice correto. Veja:

```js
var regex = /[[0-9]]/g;

$('.artista').each(function(index) {
  var $campos  = $(this).find('input'),
      $input  ,
      name    ;

  $campos.each(function() {
    $input  = $(this),
    name  = $input.attr('name');

    $input.attr('name', name.replace(regex, '[' + index + ']'));
  });
});
```

Veja que inicialmente criamos uma [regex](http://en.wikipedia.org/wiki/Regular_expression) que busca extamente a parte do name do campo no qual mantém o índice da lista. Então percorremos todos os "artistas" (containers) para executarmos a ação de ordenação em cada um deles.

Veja que possuimos um argumento chamado `index` que indica a posição de cada um dos artista e é com ele que iremos fazer a reordenação, ou seja, o primeiro container receberá o índice 0, o segundo o índice 1 e assim por diante.

Para cada um desse container pegamos todos os campo e para cada um destes campos pegamos o valor do seu `name` e substituimos o número de seu índice pelo índice corrente da iteração do `.each()`. Com isso garantimos a ordem tanto na adição quanto na remoção dos artistas.

Quando trabalhamos apenas com um valor para cada entidade não há problema algum em deixarmos os names sem índices `filme.artistas[].nome`, já que o VRaptor irá preenchê-los na ordem que vieram da tela, porém quando temos mais de um campo, devemos manter o índice atualizado, pois só assim saberemos quais campos fazem parte da mesma entidade.

Esta estratégia de criação dinâmica foi utilizado na adição de questões do [Mockr.me](http://mockr.me)

### Link do projeto:

[http://github.com/wbotelhos/manipulando-listas-jquery-vraptor-3](http://github.com/wbotelhos/manipulando-listas-jquery-vraptor-3)
