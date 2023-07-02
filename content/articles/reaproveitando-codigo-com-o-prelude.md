---
date: 2011-04-18T00:00:00-03:00
description: "Reaproveitando Código Com o Prelude"
tags: ["prelude", "java"]
title: "Reaproveitando Código Com o Prelude"
url: "reaproveitando-codigo-com-o-prelude"
---

Ao se trabalhar com [Taglibs](http://tomcat.apache.org/taglibs) em páginas JSP é normal a necessidade da importação de cada uma das bibliotecas utilizadas. Com o passar do tempo e o crescimento do projeto, fica um tanto quanto incômodo essas importações já que a quantidade de páginas se tornam cada vez maiores.

A situação se complica ainda mais quando utilizamos algum *web-page layout* como o [Sitemesh](http://www.wbotelhos.com.br/2010/07/01/criando-template-com-sitemesh) e queremos importar essas bibliotecas diretamente no *template* para evitar retrabalho, mas nos deparamos com um erro de importação. Essa idéia não funciona, já que a decoração do template é feita em *runtime* e as bibliotecas são necessárias em tempo de compilação.

Veremos uma forma facilitada de fazer a importação das Taglibs com o Prelude de forma transparente e sem maiores esforços.

### Objetivo:
Criar uma página Prelude para manter os *imports* das Taglibs necessárias e colocá-la como *include* automático nas outras páginas evitando o retrabalho de importação.

### Criando o Prelude:

Será criado uma página com uma nova extensão chamada **prelude.jspf**, dentro de *WEB-INF/jsp*, que manterá os *imports* que serão utilizados:

```jsp
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
```

Nesta página poderá ser importada qualquer Taglib desejada, assim como códigos que devem estar presentes em todas as páginas como, por exemplo, o de alteração do locale do sistema.

E por fim basta que este prelude seja mapeado e configurado no web.xml:

```xml
<jsp-config>
  <jsp-property-group>
  <url-pattern>*.jsp</url-pattern>
  <page-encoding>ISO-8859-1</page-encoding>
  <include-prelude>/WEB-INF/prelude.jspf</include-prelude>
  </jsp-property-group>
</jsp-config>
```

O `url-pattern` indica que os arquivos terminados com .jsp terão o Prelude incluído como "cabeçalho". Também foi configurado o *encode* da página e o caminho do arquivo.

O *include* pode ser testado em páginas distintas usando algumas tags:

```jsp
<c:set var="text" value="CoffeeScript" />

<c:out value="Core works!" />

<c:out value="${fn:length(text)}" />

<fmt:setLocale value="en_US"/>
<fmt:formatNumber type="currency" value="42000"/>
```

Aqui foi utilizada as Taglibs Core, Function e Format sem a necessidade da importação explícita.
Desta forma conseguimos trabalhar sem nos preocupar tanto com coisas triviais, agilizando o desenvolvimento.

### Link do projeto:
[https://github.com/wbotelhos/reaproveitando-codigo-prelude](https://github.com/wbotelhos/reaproveitando-codigo-prelude)
