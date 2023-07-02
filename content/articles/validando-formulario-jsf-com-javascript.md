---
date: 2009-08-03T00:00:00-03:00
description: "Validando Formulário JSF com JavaScript"
tags: ["java", "jsf", "javascript", "validacao"]
title: "Validando Formulário JSF com JavaScript"
url: "validando-formulario-jsf-com-javascript"
---

Vamos ver como validar um formulário JSF com [Javascript](http://pt.wikipedia.org/wiki/Javascript). A princípio é simples, porém existe um detalhe e este detalhe no final se torna um conceito necessário para todos aqueles desenvolvedores JSF, chamado de **Naming Container**.

Para que possamos validar um campo, este deve conter um identificador *ID* para servir de "âncora" para nosso script.
<blockquote>Vale lembrar que o ID é uma identificação única, logo se tivermos dois componentes com o mesmo ID o JSF acusará um erro, e lançará uma exceção: "Duplicate component id".</blockquote>

**Passos:**

1. Criar um fomulário com os campos usuario, senha e confirmação de senha;
2. Identicar os componentes; e
3. Criar um script que valide o formulário.

**Formulário:**

```java
<h:form> // << Atenção!
  ...
  <h:outputText value="Usuário:"/>
  <h:inputText id="usuario"/>

  <h:outputText value="Senha:"/>
  <h:inputSecret id="senha"/>

  <h:outputText value="Confirmação:"/>
  <h:inputSecret id="confirma"/>

  <h:commandButton value="Confirmar" onclick="return validar(this.form);"/>
  ...
</h:form>
```

Montamos o formulário com os três campos e suas respectivas identificações e um botão que chama uma função javascript de nome `validar` passando o formulário corrente como parâmetro. Agora devemos declarar o script na página:

```html
<head>
  <script type="text/javascript" src="/javascript.js"></script>
</head>
```

E então poderemos criar nosso script utilizando os ids como referência e assim capturando os valores dos campos, mas é ai que acabamos vacilando. Se tentarmos capturar o valor do campo "usuario" do modo descrito abaixo, não dará certo, pois o JSF trabalha com o conceito de hierarquia dos componente, ou seja, o Naming Container:

```js
function validar(form) {
  var usuario = form["usuario"].value;
  ...
}
```

Veja que estamos buscando o id de nome "usuario", porém nosso código gerou algo como:

```html
<form id="j_id_jsp_1070816059_1" name="j_id_jsp_1070816059_1">
  <input id="j_id_jsp_1070816059_1:usuario" name="j_id_jsp_1070816059_1:usuario"/>
</form>
```

Veja que foi concatenado ao nosso ID "usuario" um ID especial **j_id_jsp_1070816059_1**. Mas de onde veio este ID? Veio do componente mais externo, que por ser um naming container, repassou sua ID para seus componentes internos e é por isso que nosso script não iria funcionar já que a ID final ficou: "**j_id_jsp_1070816059_1:usuario**". O JSF gera um ID não muito legível, assim como um `name` automaticamente caso nós não o especifiquemos. Logo devemos especificá-lo para conseguirmos manipulá-lo.

```java
<h:form id="form">
  ...
</h:form>
```

Desta forma como já sabemos que os IDs serão concatenados do componente mais "externo" até o nosso componente mais "interno" e já especificamos um ID para o form, teríamos acesso ao campo da seguinte forma:

```js
function validar(form) {
  var usuario = form['form:usuario'].value;
  ...
}
```

Alguns poderiam pensar ser possível fazer o acesso ao valor do campo da seguinte forma:

```js
var usuario = documents.forms.form.usuario.value;
```

Porém como vimos temos o sinal de dois pontos ':' entre as IDs, o que nos impossibilita tal ação. Porém temos formas mais elegantes de acesso aos dados, utilizando o `getElementById()` e evitando passar o formulário como parâmetro:

```js
var usuario = document.getElementById('form:usuario').value;
```

Você pode estar se questionando o porquê de sempre termos de indicar o ID do componente mais externo, sendo que se tivéssemos mais outros componentes naming containers teríamos de fazer várias concatenações de IDs. Mas o JSF já deu um jeitinho bem legal de resolver isso com apenas um atributo chamado `**prependId**`. Basta inserirmos ele na tag `<h:form>` e seu ID não será herdado pelos componentes internos:

```java
<h:form prependId="false">
  ...
</form>
```

Neste caso indicamos que o `prependId` será falso, ou seja, o *prepend* que da idéia de anterior (componente anterior, externo, pai) não passará seu ID adiante. Por padrão este atributo é true. Vale lembrar que mesmo o ID não sendo passado para os componentes internos, o formulário continua com um ID, seja ele gerado automaticamente ou por você próprio ficando assim:

```html
<form id="j_id_jsp_1070816059_1" name="j_id_jsp_1070816059_1">
  <input id="usuario" name="usuario"/>
</form>
```

Desta forma já podemos acessar os valores de forma fácil e moderna, não precisando de passar o formulário como parâmetro e acessando os valores dos campos diretamente:

**Formulário:**

```js
<h:form prependId="false">
  ...
  <h:commandButton value="Confirmar" onclick="return validar();"/>
  ...
</h:form>
```

**Javascript:**

```js
function validar() {
  var usuario = document.getElementById('usuario');
  var senha = document.getElementById('senha');
  var confirmar = document.getElementById('confirmar');

  if (usuario.value == '' || senha.value == '' || confirmar.value == '') {
    alert('Por favor, preencha todos os campos!');
    return false;
  } else if (senha.value != confirmar.value) {
    alert('Ops! A senha não confere.');
    confirmar.focus();
    return false;
  }

  alert("Ok! Seu formulário esta válido! (:");
  return true;
}
```

Neste script primeiramente capturo os dados a partir de seus IDs, agora solitários, e com isso pego os valores dos campos e comparo se algum deles esta vazio, apresentando uma mensagem para o usuário e retornando `false` caso seja verdade ou se a senha não for igual a senha de confirmação, no qual, dou um foco no campo e também alerto o usuário. Caso contrário apenas aviso o usuário que o formulário esta ok e retorno **true** para o método `onSubmit` do formulário que diante disso submete o mesmo.

**Conclusão:**

O Javascript dominou a web e é usado em todas aplicações hoje em dia e com JSF não é diferente, aqui ele também esta presente e não só podemos como devemos usufruir deste recurso. O JSF tem seus próprios validadores nos quais passam pelo [ciclo de vida](http://www.ibm.com/developerworks/library/j-jsf2/) do JSF fazendo uma requisição ao servidor, porém a grande jogada do javascript é exatamente não fazer requisições ao servidor economizando recursos, mas sim ser executado do lado do cliente.

Mas cuidado, como o javascript roda do lado do cliente ele pode ser facilmente desabilitado ou bloqueado, então o ideal seria uma validação tanto [client side](http://pt.wikipedia.org/wiki/Server-side) como [server side](http://pt.wikipedia.org/wiki/Client_Side_Scripts).

> Perceba que este artigo é didático e a intenção foi mostrar as formas de acesso em baixo nível pelo JavaScript, porém o ideal é a utilização de uma framework como, por exemplo, o [jQuery](http://jquery.com).

**Link do projeto**:

[http://github.com/wbotelhos/validando-formulario-jsf-javascript](http://github.com/wbotelhos/validando-formulario-jsf-javascript)
