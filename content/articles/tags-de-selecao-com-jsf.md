---
date: 2009-06-24T00:00:00-03:00
description: "Tags de Seleção com JSF"
tags: ["jsf", "select"]
title: "Tags de Seleção com JSF"
url: "tags-de-selecao-com-jsf"
---

Vamos falar um pouco sobre as tags de seleção do JSF. Estas tags são abstrações dos componentes HTML de type checkbox, radio etc. Além de termos a vantagem da escrita amigável, temos opções pré definidas de formatação e uma maior facilidade de vinculação com um [JavaBean](http://pt.wikipedia.org/wiki/JavaBeans).

Para aqueles que não sabem, temos 7 (sete) tags de seleção:

```java
selectBooleanCheckbox
selectManyCheckbox
selectOneRadio
selectOneListbox
selectManyListbox
selectOneMenu
selectManyMenu
```

Todas as tags de seleção começam com o nome **select** e se dividem em 4 (quatro) tipos: `CheckBox`, `Radio`, `List` e `Menu`. Cada um destes menos o `Radio` possuem duas formas, uma de seleção única (`One`) e outra de seleção múltipla (`Many`).

A tag `<h:selectBooleanCheckbox/>` é a tag mais simples, no qual apresenta uma única opção de escolha que poderá ser vinculada a um atributo booleano, veja um exemplo:

# selectBooleanCheckbox

```java
<h:outputText value="Ativo?:"/>
<h:selectBooleanCheckbox value="#{bean.ativo}"/>
```

Temos uma opção, onde se pode marcar como verdadeira ou falsa, no caso, se uma pessoa esta ativa ou não. O valor estará vinculado ao atributo "ativo" contido no backing bean chamado "bean". Teremos um atributo booleano e os métodos `get` e `set` para recuperar e atribuir os valores da seleção:

```java
public class Bean {

  private boolean ativo;

  // get e set

}
```

Esta tag tem apenas um item de seleção, porém as outras possuem mais de um, nos quais devem ser especificados. Uma maneira direta de especificá-los é utilizar a tag `<f:selectItem/>`. Você poderá usar os dois atributos básico desta tag que é o valor e o nome do item:

```java
<f:selectItem itemValue="M" itemLabel="Masculino"/>
```

O valor 'M' é passado como parâmetro de requisição quando o formulário é submetido.

Vejamos um conjunto de botões de rádio utilizando a tag `<h:selectOneRadio/>` em conjunto com a tag `<f:selectItem/>`:

# selectOneRadio

```java
<h:outputText value="Sexo:"/>
<h:selectOneRadio value="#{bean.sexo}" layout="pageDirection">
  <f:selectItem itemValue="M" itemLabel="Masculino"/>
  <f:selectItem itemValue="F" itemLabel="Feminino"/>
</h:selectOneRadio>
```

Um importante atributo do `selectOneRadio` e do `selectManyCheckbox` além de `border` para especificar uma borda, `enabledClass` e `disabledClass` para aplicar um estilo quando o componente estiver habilitado e desabilitado respectivamente, é o `layout`, que especifica como será dipostos os menus: horizontal ou vertical. Por padrão o componente é `lineDirection` (horizontal), mas podemos colocá-lo como `pageDirection` (vertical).

Podemos vincular um único `selectItem` a um atributo `SelectItem` do backing bean:

```java
<f:selectItem value="#{bean.femininoItem}"/>
```

```java
public class Bean {

  private SelectItem femininoItem ;

  public Bean() {
    femininoItem = new SelectItem("F", "Feminino");
  }

  // get e set

}
```

Veja que Sexo possue duas opções, logo utilizei a tag de Item duas vezes, porém esta opção seria um tanto inviável para menus com muitos itens de seleção ou dinâmicos, nos quais os valores não são fixos. A maneira para contornarmos esta restrição é utilizar a tag composta `<h:selectItems/>`.

Esta tag deverá estar vinculada a um backing bean com um atributo que seja um único `SelectItem`, `Collecion`, `Array` ou um `Map` com duas entradas representando os rótulos e os valores de `SelectItem`, além de um atributo no qual você colocará o(s) valor(es) selecionado(s).

Vejamos um conjunto de caixas de seleção, nas quais posso selecionar uma ou mais opções:

# selectManyCheckbox

```java
<h:outputText value="Matérias:"/>
<h:selectManyCheckbox value="#{bean.materias}">
  <f:selectItems value="#{bean.materiasItems}"/>
</h:selectManyCheckbox>
```

Cada entrada do mapa será convertida para uma instância de SelectItem. A chave será o rótulo e o valor de entrada será o valor do item. Como no mapa não explicitamos o SelectItem, não conseguimos utilizar outros atributos desta tag como a descrição por exemplo.

Ao utilizarmos um mapa devemos ter em mente que:
- O LinkedHashMap colocará os itens na ordem de inserção;
- O TreeMap será ordenado em ordem alfabética; e
- HashMap será ordenado de forma aleatória.

Backing bean utilizando um mapa:

```java
public class Bean {

  private String[] materias;
  private Map<string, Object> materiasItems;

  public Bean() { // "public" se faz necessário.
    materiasItems = new LinkedHashMap<string, Object>();
    materiasItems.put("Português", "pt");
    materiasItems.put("Inglês", "en");
  }

  // get e set

}
```

O primeiro parâmetro do `Mapa` representará o rótulo do `SelectItem` e o segundo o valor.
Para você lembrar o que poderá ser especificado para `selectItem` basta lembrar de **SCAM**:

```java
SelectItem
Collection
Array
Map
```

Repare que estou inicializando o mapa no construtor padrão do backing bean, mas na maioria das vezes buscaremos de um banco de dados.

Agora que estamos familiarizados com o modo de inserir os itens e os possiveis elementos para adicioná-lo, vejamos os restantes das tags de caixa de listagem e menu:

# selectOneListbox

```java
<h:outputText value="Ano:"/>
<h:selectOneListbox value="#{bean.ano}" size="7">
  <f:selectItems value="#{bean.anosItems}"/>
</h:selectOneListbox>
```

Um atributo interessante é o `size`, ele indicará quantos itens serão visíveis na caixa de seleção. Caso você especifique um valor menor do que o total de itens, será adicionado um scroller, caso não especifique o atributo a caixa de seleção se ajustará à quantidade de itens, que no caso é o comportalmente padrão.

Backing bean utilizando uma coleção:

```java
public class Bean {

  private int ano;
  private Collection<selectItem> anosItems;

  public Bean() {
    anosItems = new ArrayList<selectItem>();
    for (int i = 1990; i <= 2000; i++) {
      anosItems.add(new SelectItem(i));
    }
  }

  // get e set

}
```

# selectManyListbox

```java
<h:outputText value="Dias:"/>
<h:h:selectManyListbox value="#{bean.diasSemana}" style="height: 110px;">
  <f:selectItems value="#{bean.diasSemanaItems}"/>
</h:h:selectManyListbox>
```

Quando esta tag é renderizada para HTML, a única diferença dela para a tag `OneList` é o atributo `muiltiple` para indicar a possibilidade de múltiplas escolhas.

* Para selecionar mais de um item basta clicar segurar e selecioná-los, porém para seleções não consecutivas se faz necessário segurar a tecla **Ctrl**.


Backing bean utilizando um array:

```java
public class Bean {

  private String[] diasSemana;
  private SelectItem[] diasSemanaItems = {
    new SelectItem("Domingo"),
    new SelectItem("Segunda"),
    new SelectItem("Terça"),
    new SelectItem("Quarta"),
    new SelectItem("Quinta"),
    new SelectItem("Sexta"),
    new SelectItem("Sábado")
  };

  // get e set

}
```

**selectOneMenu **

```java
<h:outputText value="Aprovado:"/>
<h:selectOneMenu value="#{bean.aprovado}">
  <f:selectItems value="#{bean.aprovadoItems}"/>
</h:selectOneMenu>
```

Os dois tipos de menus também têm uma diferença muito simples: o `OneMenu` simplesmente adiciona o atributo `size="1"` para indicar que só aparecerá um item, com isso o navegador em vez de criar um `scoller` cria um botao `dropdown` pelo fato da tag ser `Menu`.

Backing bean utilizando um array:

```java
public class Bean {

  private String aprovado;
  private SelectItem[] aprovadoItems = {
    new SelectItem("Sim"),
    new SelectItem("Não")
  };

    // get e set

}
```

**selectManyMenu **

```java
<h:outputText value="Requisitos:"/>
<h:selectManyMenu value="#{bean.requisitos}">
  <f:selectItems value="#{bean.requisitosItems}"/>
</h:selectManyMenu>
```

O menu de múltiplas escolha tem um pequeno problema: se é um `Menu`, ele terá o `size="1"`, se é `Many` terá o atributo `multiple`. Mas repare só, eu posso selecionar várias opções, mas só enxergarei um item por vez na tela. Sim, realmente assim será, pois os navegadores não criam um menu `dropdown` no qual se pode selecionar mais de uma opção, até mesmo porque no clique o `dropdown` é desativado e setado a escolha do usuário. Em vez disso o navegador coloca um `scroller` minúsculo no qual se deve selecionar um item e passar para o próximo não tendo uma visualização de todas as opções. Outros navegadores nem mesmo colocam o `scroller` o que nos obrigam a navegarmos pelos itens através do teclado.

Backing bean utilizando um array:

```java
public class Bean {

  private String[] requisitos;
  private SelectItem[] requisitosItems = {
    new SelectItem("Bacharel"),
    new SelectItem("Pós Graduação"),
    new SelectItem("Mestrado"),
    new SelectItem("Doutorado")
  };

    // get e set

}
```

Para todas as tags vista menos a `selectBooleanCheckbox` podemos fazer agrupamentos de itens.

**SelectItemGroup**

Agora trabalharemos com grupos de `SelectItem` em vez do `array`:

```java
private SelectItemGroup meuGrupo = new SelectItemGroup("Nome", "Descrição", true, selectItems);
```

Temos como atributo o nome do grupo, a descrição, se está ativo ou não e o `array` de `SelectItem`.

Vejamos um exemplo utilizando `selectManyListbox`:

```java
<h:outputText value="Currículo:"/>
<h:selectManyListbox value="#{bean.curriculo}">
  <f:selectItems value="#{bean.curriculoItems}"/>
</h:selectManyListbox>
```

Teremos um `array` de `SelectItem` e um de resultado da mesma forma que fizemos antes, porém em vez do `array` de `SelectItem` receber instâncias de `SelectItem`, receberá vários `SelectItemGroup` que por sua vez possue as instâncias de `SelectItem`. Isto é possível porque `SelectItemGroup` estende `SelectItem`.

```java
import javax.faces.model.SelectItem;
import javax.faces.model.SelectItemGroup;

public class Bean {

  private SelectItem[] javaItems = {
    new SelectItem("Java SE"),
    new SelectItem("Java EE"),
    new SelectItem("JSP")
  };

  private SelectItem[] conhecimentosItems = {
    new SelectItem("JSF"),
    new SelectItem("Hibernate"),
    new SelectItem("EJB"),
    new SelectItem("Facelets")
  };

  private SelectItemGroup javaGroup = new SelectItemGroup("Java", "Linguagens Java", true, javaItems);
  private SelectItemGroup requisitosGroup = new SelectItemGroup("Requisitos", "Conhecimentos", true, conhecimentosItems);

  private String[] curriculo;
  private SelectItem[] curriculoItems = {javaGroup, requisitosGroup};

  // getters e setters

}
```

Agora já sabemos manipular todas as tags de seleção do JSF, falta saber como apresentar os resultados. Os resultados mantidos em um vetor por poderem ser mais que um valor, não podem ser impressos diretamente igual um valor vindo de `selectOneBooleanCheckbox` e armazenado em uma `int` por exemplo:

```java
<h:outputText value="Ativo?:"/>
<h:selectBooleanCheckbox value="#{bean.ativo}"/>
```

Teremos então de pegar cada valor do vetor, montar uma string e ai sim retorná-la. Podemos fazer um método que concatena todos os valores do vetor e retorna uma String montada:

```java
  private String concatenar(Object[] vet) {
    if (vet == null) {
      return "";
    }

    StringBuilder builder = new StringBuilder();

    for (Object ite : vet) {
      if (builder.length() > 0) {
        builder.append(", ");
      }

      builder.append(ite.toString());
    }

    return builder.toString();
  }
```

Também precisaremos de um método `get` para retornar a String concatenada:

```java
  public String getDiasSemanaDisplay() {
    return concatenar(diasSemana);
  }
```

Então para todos os atributos que possuem mais que um valor teremos de ter um método `get` alternativo para apresentação dos mesmos. Mas não omita o `get` que retorna o vetor, pois ele é necessário para renderização do valor selecionado no componente.

Em um formulário utilizamos estas tags várias vezes tornando-se essenciais para qualquer tipo de aplicação.
Todas elas suportam formatação de estilo com CSS e atributos próprios para que você possa utilizá-las da melhor forma possível.

**Link do projeto**:

[http://github.com/wbotelhos/tags-selecao-jsf](http://github.com/wbotelhos/tags-selecao-jsf)
