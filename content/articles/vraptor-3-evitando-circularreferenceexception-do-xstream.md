---
date: 2010-08-25T00:00:00-03:00
description: "VRaptor 3 - Evitando CircularReferenceException do XStream"
tags: ["java", "vraptor", "circular-reference-exception", "xstream"]
title: "VRaptor 3 - Evitando CircularReferenceException do XStream"
---

Quem utiliza a serialização [JSON](http://www.json.org) do [VRaptor 3](http://vraptor.caelum.com.br) em algum momento já se deparou com a
`CircularReferenceException` ao trabalhar com coleções. O [XStream](http://xstream.codehaus.org) da [Thoughtworks](http://www.thoughtworks.com) é o responsável por essa serialização e hoje iremos falar um pouco dessa biblioteca.

### Objetivo:

Entender alguns conceitos do [Hibernate](http://www.hibernate.org), assim como entender e evitar o `CircularReferenceException` do XStream na serialização JSON de um objeto retornado que possua uma coleção.

Primeiramente vamos entender alguns conceitos:

### FetchType.LAZY e FetchType.EAGER

Um objeto que possua uma coleção anotada com `FetchType.LAZY` não terá esta carregada junto ao objeto no qual pertence, diferentemente se anotássemos com `FetchType.EAGER` que já carrega a coleção junto ao seu objeto. O `LAZY` só carrega a coleção de fato, quando a requisitamos através de um método `get`.

Se eu pesquisasse o seguinte usuário no banco, eu já teria de "prima" a lista de mensagens, mas não a de filmes:

```java
@Entity
public class Usuario {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  private String nome;

  @OneToMany(mappedBy = "usuario", fetch = FetchType.LAZY)
  private Collection<Filme> filmeList;

  @OneToMany(mappedBy = "usuario", fetch = FetchType.EAGER)
  private Collection<Mensagem> mensagemList;

  // getters and setters

}
```

> A propósito, não é necessário declarar que uma lista é `LAZY`, pois por padrão é esta sua configuração.

A lista de mensagens já é carregada logo na consulta do usuário, pois esta configurada como `EAGER` (Ansiosa), porém a de filme é uma lista `LAZY` (preguiçosa) e só será carregada quando fizermos:

```java
Usuario usuario = usuarioDao.loadById(1l); // Já temos a lista de mensagens carregada.
Collection<Filme> filmeList = usuario.getFilmeList(); // Busca a lista de filmes somente neste momento.
```

Você pode estar se perguntando: qual era o valor dessa lista anteriormente? Como o Hibernate consegue buscar a lista a partir de um `get`? E ai que entra um outro conceito.

### Hibernate Proxy:

O Hibernate por padrão com a ajuda da [CGLIB](http://cglib.sourceforge.net) (Code Generation Library) cria um Proxy para cada classe que você mapea. Esse Proxy é uma representação do seu objeto, contendo a mesma interface e um código para invocar a JDBC.

Quando consultamos nosso objeto `Usuario` o que o Hibernate nos retorna na verdade é um Proxy e não a nossa lista real. O Proxy implementa `PersistentBag`, logo ele sabe como invocar métodos no banco para fazer as consultas.

> Não se iluda com o `FetchType.EAGER`, pois ele não evitará a exception. Ele unicamente carregará nosso target evitando a ida no banco posteriormente.

Agora que você já conhece um pouco mais do Hibernate, vamos nos focar na seguinte exception:

`com.thoughtworks.xstream.core.TreeMarshaller$CircularReferenceException`

Isso ocorre porque o Hibernate nos retorna uma [PersistentBag](http://docs.jboss.org/hibernate/core/3.2/api/org/hibernate/collection/PersistentBag.html) que contém uma referência para a classe na qual ela pertence causando a referência cíclica. O XStream sabe converter apenas algumas implementações como [ArrayList](http://download.oracle.com/javase/1.4.2/docs/api/java/util/ArrayList.html), [LinkedList](http://download.oracle.com/javase/1.4.2/docs/api/java/util/LinkedList.html"), [HashSet](http://download.oracle.com/javase/1.4.2/docs/api/java/util/HashSet.html) e poucas outras, mas para o `PersistBag` ele serializa da forma padrão: cada campo, inclusive o da referência da instância, o que causa a referência cíclica.

### Evitando a serialização do Proxy:

Para resolvermos isso precisaremos extender a classe `XStreamJSONSerialization` e fazer um pequeno ajuste na serialização.

```java
@Component
public class CustomJSONSerialization extends XStreamJSONSerialization {

  public CustomJSONSerialization(HttpServletResponse response, TypeNameExtractor extractor, ProxyInitializer initializer) {
    super(response, extractor, initializer);
  }

  @Override
  protected XStream getXStream() {
    XStream xstream = super.getXStream();

    xstream.registerConverter(new CollectionConverter(xstream.getMapper()) {
      @Override
      @SuppressWarnings("rawtypes")
      public boolean canConvert(Class type) {
        return Collection.class.isAssignableFrom(type);
      }
    });

    return xstream;
  }

}
```

Criamos um Component que extende `XStreamJSONSerialization`. Ela recebe suas dependências e sobrescreve o método `getXStream()`.

Recuperamos o método pai "original" e registramos um conversor através do método `registerConverter`. Este método recebeu uma instância de `CollectionConverter` que também terá o método `canConvert` sobrescrito, que por sinal tem o nome bem sugestivo.

Agora nossas coleções só serão serializadas se forem coleções de fato, evitando a tentativa da serialização de um Proxy. Você pode registrar quantos Converters quiser, por exemplo, um para trabalhar com `Map`:

```java
xstream.registerConverter(new MapConverter(xstream.getMapper()) {
  @Override
  @SuppressWarnings("rawtypes")
  public boolean canConvert(Class type) {
    return Map.class.isAssignableFrom(type);
  }
}
```

Pronto! Agora você já pode serializar suas listas tranquilamente. (:

> Esse problema já foi solucionado na versão 3.1.3, mas vale a pena pelo aprendizado. (;

### Link do projeto:

[http://github.com/wbotelhos/vraptor-3-evitando-circularreferenceexception-do-xstream](http://github.com/wbotelhos/vraptor-3-evitando-circularreferenceexception-do-xstream)
