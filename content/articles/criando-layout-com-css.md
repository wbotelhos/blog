---
date: 2010-05-24T00:00:00-03:00
description: "Criando Layout com CSS"
tags: ["css", "layout"]
title: "Criando Layout com CSS"
---

Sabemos que para nós não designers, montar um layout não é algo tão trivial assim, até mesmo porque as vezes não é a falta de conhecimento, mas sim a falta de criatividade que nos falta. Veremos como montar um layout com caixas flutuantes (widgets) e bordas arredondadas utilizando [CSS](http://pt.wikipedia.org/wiki/Cascading_Style_Sheets).

### Objetivo:

Criar um layout com topo, menu, conteúdo, rodapé, área lateral esquerda e direita contendo caixas flutuantes dentro destas.

### Esboço do design:

<center>
<a href="http://www.flickr.com/photos/wbotelhos/7647152306" target="_blank">
  <img src="http://farm9.staticflickr.com/8026/7647152306_645786fba5.jpg" alt="Esboço do design" width="500" height="431" />
</a>
</center>

### Criando o projeto e as páginas:

Vamos criar um projeto e adicionar as seguintes páginas para representar cada parte numerada na imagem acima.

<center>
<a href="http://www.flickr.com/photos/wbotelhos/7641026462" target="_blank">
  <img src="http://farm9.staticflickr.com/8157/7641026462_966d719ea7_m.jpg" alt="Páginas JSP" title="Páginas JSP" height="173" width="120" />
</a>
</center>

Convertemos a imagem em páginas, agora vamos implementar o código das páginas.

### Criando os containers (frame.jsp):

Nossas [divs](http://maujor.com/tutorial/divmania.php) nada mais são do que containers para manter nossos elementos alinhados e estilisados, por isso iremos acumulá-los em um só lugar, mas onde? Repare que temos a página de número 0 (zero) não esboçada no desenho, a `frame.jsp`, ela manterá todos os nossos containers.

```html
<body id="corpo">
    <div id="geral"> <!-- 0 -->

       <div id="topo"></div> <!-- 1 -->
       <div id="menu"></div> <!-- 2 -->

       <div id="conteudo">
           <div id="esquerda"> <!-- 3 -->
               <div id="info"></div> <!-- 7 -->
           </div>

             <div id="sub-conteudo"></div> <!-- 4 -->

           <div id="direita"> <!-- 5 -->
               <div id="top-filme"></div> <!-- 8 -->
               <div id="top-usuario"></div> <!-- 9 -->
           </div>
       </div>

       <div id="rodape"></div> <!-- 6 -->
    </div>
</body>
```

Repare que cada container possui um identificador (ID) próprio, que nos serve de âncora para aplicarmos o CSS.

### Importando as páginas:

O próximo passo é importar as páginas enumeradas para dentro dos seus respectivos container.

```html
<body id="corpo">
    <div id="geral"> <!-- 0 -->

       <div id="topo"><%@ include file="/topo.jsp" %></div> <!-- 1 -->
       <div id="menu"><%@ include file="/menu.jsp" %></div> <!-- 2 -->

       <div id="conteudo">
           <div id="esquerda"> <!-- 3 -->
               <div id="info"><%@ include file="/info.jsp" %></div> <!-- 7 -->
           </div>

             <div id="sub-conteudo"><jsp:include page="/index.jsp"/></div> <!-- 4 -->

           <div id="direita"> <!-- 5 -->
               <div id="top-filme"><%@ include file="/topFilme.jsp" %></div> <!-- 8 -->
               <div id="top-usuario"><%@ include file="/topUsuario.jsp" %></div> <!-- 9 -->
           </div>
       </div>

       <div id="rodape"><%@ include file="/rodape.jsp" %></div> <!-- 6 -->
    </div>
</body>
```

> As páginas esquerda.jsp e direita.jsp, não existirem, sendo representadas por divs.

Utilizamos dois tipos de imports: action (`jsp:include`) e a diretiva (`<%@ include %>`). Mas qual é a diferença entre elas?

**Diretiva**:

+ Inclue o conteúdo na fase de compilação, combinando os dois arquivos e gerando um só;
+ Elementos declarados em uma página pode ser usados em outra, por serem no final uma só; e
+ Alterações em uma página nem sempre são visíveis à página que a importa, sendo necessário recompilá-la.

**Action**:

+ Inclui o resultado da execução do arquivo quando a página que a inclui é requisitada;
Usada para arquivos que sofrem alterações constantes; e
+ Como é o conteúdo gerado pela página, e não a página em si, que será incluído, pode-se escolher qual arquivo será incluído em tempo de execução.

<span style="font-size: xx-small;">[Fonte](http://bit.ly/apnpic)</span>

Quando você possuir um conteúdo dinâmico, no qual a página é decidida durante a navegação como:

```html
    <jsp:include page="${param.pagina}"/>
```

Não tenha dúvida em utilizar a action, pois somente ela permite parametrizar o conteúdo importado, por ser decidido isso em tempo de execução. (;

### Criando e importando o CSS:

Primeiramente vamos criar uma pasta chamada `css` contendo um arquivo chamado de `frame.css`.

<center>
<a href="http://www.flickr.com/photos/wbotelhos/7641026534" target="_blank">
  <img src="http://farm8.staticflickr.com/7108/7641026534_e7017a0b9f_m.jpg" alt="Arquivo CSS" title="Arquivo CSS" height="52" width="133" />
</a>
</center>

E logo em seguida importá-lo na página `frame.jsp`

```html
    <link type="text/css" rel="stylesheet" href="<c:url value='/css/frame.css'/>" />
```

Nosso layout por enquanto esta desta forma:

<center>
<a href="http://www.flickr.com/photos/wbotelhos/7641026600" target="_blank">
    <img src="http://farm9.staticflickr.com/8166/7641026600_34d6a655f9.jpg" title="Layout Parte 1" alt="Layout Parte 1"  height="251" width="500" />
</a>
</center>

Agora falta apenas criarmos os estilos para cada container existente de acordo com seu ID.

### Revisão rápida e dicas:

**#** = ID
**.** = Classe

É sempre bom indicar o elemento que estamos trabalhando antes do indicador de ID ou classe, além de ficar mais legível, o estilo mais detalhado tem maior prioridade:

**input**: aplicado em todos os elementos inputs.
**div**.caixa-lateral: aplicado em elementos div com classe de nome caixa-lateral.
**select**#estado: aplicado em elementos select com ID chamado estado.

Tente separar seus estilos por ordem alfabética e grupos:
1. Nome do componente: **d**iv, **i**nput, **s**pan...;
2. Nome da classe ou ID: div#**b**orda-especial, div.**c**anto-destaque, div#**t**itulo...;
3. Nome do atributo: **c**olor: #000, **b**ackground-color: #FFF, **w**idth: 23px....

> Cada um tem seu jeito, porém esta forma me ajuda muito e talvez te ajude também. (:

### Criando estilo para os containers:

<span style="text-decoration: underline;">Corpo e Geral</span>:

```css
body#corpo {
    background-color: #EEF4FB;
    font: 10px verdana;
}
```

Nosso corpo da página tem um fundo colorido, tamanho e tipo de fonte fixo para todo o sistema.

```css
div#geral {
    margin: 0 auto;
    width: 1100px;
}
```

Nosso container que mantém todos os outros, esta centralizado e com uma largura de tela fixa.



<a href="http://www.flickr.com/photos/wbotelhos/7641026688" target="_blank">
    <img src="http://farm9.staticflickr.com/8288/7641026688_425fc18a89.jpg" title="Layout Parte 2" alt="Layout Parte 2" height="250" width="500" />
</a>

<span style="text-decoration: underline;">Topo e Menu</span>:

```css
div#topo {
   background-color: #FFF;
   height: 110px;
   margin-bottom: 5px;
   width: 100%;
}
```

Nosso topo de fundo branco terá uma altura fixa e uma largura sempre máxima, lembrando que 100% equivale a toda largura disponível e limitada pelo container `geral`. Temos um espaçamento inferior para separar o topo do menu.

```css
div#menu {
   background-color: #FFF;
   height: 30px;
   margin-bottom: 5px;
   width: 100%;
}
```

Semelhante ao topo, temos cor de fundo, altura, largura e espaçamento separando as laterais e sub-conteúdo.

<a href="http://www.flickr.com/photos/wbotelhos/7641026848" target="_blank">
    <img src="http://farm8.staticflickr.com/7265/7641026848_16951ce01b.jpg" title="Layout Parte 3" alt="Layout Parte 3" height="252" width="540" />
</a>

<span style="text-decoration: underline;">Lateral Esquerda e Sub-Conteúdo</span>:

```css
div#esquerda {
   float: left;
   height: 430px;
   margin-right: 5px;
   width: 145px;
}
```

A lateral esquerda deve flutuar à esquerda com uma largura fixa servindo para ambas laterais, assim como uma altura igual ao sub-conteúdo, além de um espaçamento direito para separar esta lateral do sub-conteúdo.

```css
div#sub-conteudo {
   background-color: #FFF;
   float: left;
   margin-bottom: 5px;
   min-height: 430px;
   width: 830px;
}
```

Semelhante à leteral esquerda, este flutua a esquerda com uma cor de fundo, largura, espaçamento para separar o rodapé e um novo atributo que mantém uma altura mínima a este container, mesmo não existindo elementos dentro dele para preencher tal tamanho. Isso mantém o design evitando sua contração.

<a href="http://www.flickr.com/photos/wbotelhos/7641026748" target="_blank">
    <img src="http://farm9.staticflickr.com/8161/7641026748_5f8fd1022b.jpg" title="Layout Parte 4" alt="Layout Parte 4" height="251" width="500" />
</a>

<span style="text-decoration: underline;">Lateral Direita e Rodapé</span>:

```css
div#direita {
   float: right;
   height: 430px;
   margin-left: 5px;
   width: 145px;
}
```

Nossa lateral direita se comporta igual a esquerda, porém flutuando a direita.

```css
div#rodape {
   background-color: #FFF;
   clear: both;
   height: 25px;
   width: 100%;
}
```

Nosso rodapé também não há nada de novo a não ser um atributo que faz com que ele não aceite que nada fique à sua esquerda e nem à sua direita (`both`), acarretando seu isolamento abaixo, que por vez é o efeito esperado.

<a href="http://www.flickr.com/photos/wbotelhos/7641026962" target="_blank">
    <img src="http://farm9.staticflickr.com/8434/7641026962_55b2f97ec3.jpg" title="Layout Parte 5" alt="Layout Parte 5" height="251" width="500" />
</a>

<span style="text-decoration: underline;">Conteúdo, Informações, Top Filme e Top Usuário</span>:

```css
div#conteudo {
}
```

Este container mantém nossos containers centrais agrupados. Podemos centralizar todo o texto ou qualquer outro tipo de estilo. Por hora vamos deixá-lo somente para organização.

```css
div#info {
   background-color: #FFF;
   height: 200px;
   width: 140px;
}
```

Nossa caixa de informação tem uma cor de fundo para se destacar, já que as laterais não possuem uma cor de fundo.

```css
div#top-filme,
div#top-usuario {
   background-color: #FFF;
   margin-bottom: 5px;
   min-height: 190px;
   width: 140px;
}
```

Nossas duas caixas de conteúdos dinâmicos utilizam um espaçamento para separá-las assim como uma altura mínima.

<a href="http://www.flickr.com/photos/wbotelhos/7641027100" target="_blank">
    <img src="http://farm9.staticflickr.com/8431/7641027100_60846ee08b.jpg" title="Layout Parte 6" alt="Layout Parte 6" height="251" width="500" />
</a>

<span style="text-decoration: underline;">Bordas Arredondadas</span>:

Faltando agora o último acabamento, vamos criar um estilo para manter as bordas arredondadas.

```css
div#info,
div#menu,
div#rodape,
div#sub-conteudo,
div#topo,
div#top-filme,
div#top-usuario {
   border-radius: 8px; /* CSS3 */
   -khtml-border-radius: 8px; /* Safari() */
   -moz-border-radius: 8px; /* Mozilla */
   -opera-border-radius: 8px; /* Opera */
   -webkit-border-radius: 8px; /* Safari */
}
```

Aplicamos à todos os container de interesse, tal estilo. Existe uma linha de código específica para cada navegador interpretar, mas como de costume o <del datetime="2010-05-23T23:50:33+00:00">Internet Explorer</del> nos deixa na mão, não possuindo um código e nem aceitando o `border-radius` do [CSS3](http://www.css3.info).

> Se for crucial a borda arredondada no IE, utilize imagens para isso.

<center>
<a href="http://www.flickr.com/photos/wbotelhos/7641027194" target="_blank">
    <img src="http://farm9.staticflickr.com/8148/7641027194_e265583986.jpg" title="Layout Parte 7" alt="Layout Parte 7" height="251" width="500" />
</a>
</center>

Pronto! Terminamos nosso temido design, porém você ainda deverá personalizar o restante. Adicionei uns estilos à parte como exemplo:

<center>
<a href="http://www.flickr.com/photos/wbotelhos/7641026374" target="_blank">
    <img src="http://farm9.staticflickr.com/8425/7641026374_ff2b31a49e.jpg" alt="Layout Parte final" width="500" height="251" />
</a>
</center>

Criar layout não é algo trivial, requer paciência e criatividade. Apesar das brincadeiras feita com os designers, devemos parabenizá-los, pois são eles que constroem uma interface legal que enxe os olhos dos usuários misturando usabilidade, acessibilidade e interesse pelo software.

### Link do projeto:

[http://github.com/wbotelhos/criando-layout-com-css](http://github.com/wbotelhos/criando-layout-com-css)
