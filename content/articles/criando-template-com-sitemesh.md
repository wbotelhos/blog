---
date: 2010-07-01T00:00:00-03:00
description: "Criando Template com Sitemesh"
tags: ["sitemesh", "template"]
title: "Criando Template com Sitemesh"
---

É comum trabalharmos com includes em nossas páginas para evitarmos a repetição de códigos que não serão alterados. Essa com certeza é uma ótima solução, mas já pensou se tivéssemos 100 páginas? Todas elas precisariam de includes, estes em sua maioria iguais. Então por que não automatizar isso?

Para essa tarefa temos alguns web-page layouts como o [Tiles](http://tiles.apache.org) famoso no mundo [Struts](http://struts.apache.org), o [Facelets](http://facelets.java.net) do mundo [JSF](http://java.sun.com/javaee/javaserverfaces) e o [Sitemesh](http://www.opensymphony.com/sitemesh), que se destaca por ser simples e poderoso.

### Objetivo:

Criar alguns [templates](http://pt.wikipedia.org/wiki/Web_template) (decorators) com diferentes configurações utilizando o Sitemesh para automatizar a inclusão (decoração) de nossas páginas.

Para servir de decorator podemos aproveitar o layout do artigo "[Criando Layout com CSS](http://www.wbotelhos.com.br/2010/05/24/criando-layout-com-css)", assim veremos como aplicar o Sitemesh e seus benefícios.

### Criando o esboço dos templates:

Criaremos 2 (dois) diferentes decorators, principal.jsp e usuario.jsp:

<a href="http://www.flickr.com/photos/wbotelhos/7660085634" target="_blank">
<img src="http://farm8.staticflickr.com/7113/7660085634_1d399ebb7d.jpg" alt="Template Principal" title="Template Principal" width="500" height="431" class="align-center" />
</a>

O decorator principal.jsp composto por quase todos os número, menos o 4 que será o conteúdo dinâmico, será o decorator default do sistema, que irá decorar as páginas requisitadas.

<a href="http://www.flickr.com/photos/wbotelhos/7660085560" target="_blank">
<img src="http://farm8.staticflickr.com/7116/7660085560_e64d2f01e1.jpg" alt="Template Usuário" title="Template Usuário" width="500" height="431" class="align-center" />
</a>

O decorator usuario.jsp com o container número 3 sendo a parte dinâmica, será um decorator alternativo, no qual teremos opção de incluí-lo no lugar do default.

Para comerçarmos as configurações vamos baixar a última versão do Sitemesh no [site oficial](http://www.opensymphony.com/sitemesh/download.action) e adicionar a lib sitemesh-2.x.x.jar na pasta WEB-INF/lib do nosso projeto.

### Ativando o Sitemesh (web.xml):

```xml
<filter>
  <filter-name>sitemesh</filter-name>
  <filter-class>com.opensymphony.sitemesh.webapp.SiteMeshFilter</filter-class>
</filter>

<filter-mapping>
  <filter-name>sitemesh</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
```

No nosso arquivo web.xml indicamos qual é o filtro responsável por decorar nossas páginas requisitadas e qual o padrão de URL que será interceptada. Repare que poderíamos colocar /*.jsp, porém estaríamos amarrados a este padrão, então deixamos interceptar tudo a princípio e refinamos isso mais tarde.

### Flexibilidade de configuração:

O Sitemesh não nos obrigam a especificar um caminho completo, até a estensão do arquivo, isso nos da uma maior flexibilidade, pois podemos fazer regras baseado em apenas uma parte da URI. Pra quem trabalha com frameworks que desfrutam de URIs amigáveis como o [VRaptor](http://vraptor.caelum.com.br), pode fazer regras no seguinte estilo:

+ `/*/exibir/*`: http://localhost:8080/usuario**/exibir/**1</li>
+ `/*?_format=json*`: http://localhost:8080/usuario/loadByAjax/1**?_format=json**</li>

### Configurando os decorators (decorators.xml):

Este arquivo que também se encontra dentro da pasta WEB-INF manterá toda nossa lógica de decoração.

```xml
<decorators defaultdir="/decorators">
  <decorator name="principal" page="principal.jsp">
    <pattern>/*</pattern>
  </decorator>

  <decorator name="usuario" page="usuario.jsp">
    <pattern>/usuario.jsp</pattern>
  </decorator>
</decorators>
```

+ Primeiro indico o diretório onde se encontra meus decorators através do atributo `defaultdir`. Isso evita a repetição desse caminho;
+ Depois coloco minha primeira regra de decoração dizendo que qualquer tipo de URL acionada terá seu conteúdo decorado por principal.jsp. Também dou um nome para esta regra, isso é necessário;
+ Outra regra especializada falando que se a página usuario.jsp for chamada, esta será decorada pelo decorator usuario.jsp.

Bem, nossa configuração esta pronta, mas precisamos agora criar os decorators.
De acordo com o exemplo do artigo "[Criando Layout com CSS](http://www.wbotelhos.com.br/2010/05/24/criando-layout-com-css)" a única coisa que irá mudar será o conteúdo dinâmico, pois agora não podemos simplesmente colocar em tal container um include fixo desta forma:

```jsp
<div id="sub-conteudo"><%@ include file="/index.jsp" %></div>
```

Sem utilizar uma solução mais primitiva que passei [nesse comentário](http://www.wbotelhos.com.br/2010/05/24/criando-layout-com-css/#comment-147), o Sitemesh nos possibilita a inclusão do conteúdo requisitado diretamente da seguinte forma:

```jsp
<div id="sub-conteudo"><decorator:body/></div>
```

Isso faz com que o body da página requisitada seja capturado e incluído em nosso decorator, e em vez de ser renderizada a página requisitada, é renderizado o decorator com este conteúdo incluso, e esta é a mágica.

Temos outras tags de inclusão mais utilisadas como:

+ `<decorator:title default="Título padrão"/>`: Captura o título da página interceptada; e
+ `<decorator:head/>`: Captura o cabeçalho.

> Você pode deixar suas páginas sem os conteúdo `<head/>`, e o colocando diretamente no decorator. Se sua página não tiver nem mesmo a tag `<body/>` toda a página será considerada body.

### Trabalhando com excludes:

Também podemos criar regras para evitar a decoração, sendo útil principalmente para conteúdos requisitados via ajax nos formatos JSON ou XML, já que ambos não podem conter nada mais além do que seus dados bem formados.

```xml
<excludes>
  <pattern>/sobre.jsp</pattern>
  <pattern>/*/exibir*</pattern>
  <pattern>/*?exclude*</pattern>
</excludes>
```

Desta forma sempre que for chamado a página sobre.jsp nenhuma decoração será acionada.
Podemos utilizar o caracter * (asterisco) para indicar qualquer coisa em seu lugar e criar um padrão de exclusão.
Podemos também utilizar os nomes de parâmetros para indicarmos uma exclusão, no caso optei por sempre evitar a decoração quando houver o parâmetro chamado `exclude`, desta forma evito de escrever todas as combinações de URIs que quero excluir, deixando essa decisão ser feita diretamente em minhas páginas.

> Chamadas com retorno em formato JSON ou XML sempre são excluídas, então um parâmetro ajuda muito, pois precisamos apenas adicioná-lo para capturarmos o conteúdo puro sem o código adicional dos decorators.

No [site](http://www.opensymphony.com/sitemesh/documentation.action) do Sitemesh você encontra algumas outas configurações, mas posso te garantir que para a maioria das aplicações você não precisará mais do que isso. (:

### Link do projeto:

[http://github.com/wbotelhos/criando-template-com-sitemesh](http://github.com/wbotelhos/criando-template-com-sitemesh)
