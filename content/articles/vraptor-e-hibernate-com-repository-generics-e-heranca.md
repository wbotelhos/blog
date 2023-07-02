---
date: 2012-03-04T00:00:00-03:00
description: "VRaptor e Hibernate Com Repository, Generics e Herança"
tags: ["java", "vraptor", "heranca", "generics", "repository", "hibernate"]
title: "VRaptor e Hibernate Com Repository, Generics e Herança"
url: "vraptor-e-hibernate-com-repository-generics-e-heranca"
---

Uma dificuldade frequente para os desenvolvedores, iniciantes ou não, em seus primeiros projetos é como organizar a estrutura de suas aplicações. Com tantos padrões e idéias diferentes fica fácil se perder em meio às palavras abstract, interface, generics, herança, sobrescrita, sobrecarga e afins. Pensando em dar um norte para quem esta começando uma aplicação, vamos criar um projeto utilizando alguns padrões junto a esse monte de palavras que a princípio nos assutam.

### Objetivo:

Usando [VRaptor](http://vraptor.caelum.com.br) e o [Hibernate](http://hibernate.org), criar um projeto voltado a interface que tire proveito das classes genéricas e da herança.

### Herança

Como o nome mesmo já diz, a herança serve para herdar alguma coisa de alguém. Sendo assim, é muito utilizada para fazer o reaproveitamento de código, que será o nosso caso neste post. É claro que sua utilização é muito ampla como, por exemplo, tirar proveito do polimorfismo. Mas o foco deste artigo não é explicar estes conceito que já estão bem abatidos por ai. Como estamos utilizando o Hibernate poderíamos criar uma classe que mantenha o atribute `id` que cada model da aplicação obrigatoriamente deve possuir. Desta forma será criada uma classe abstrata para manter esse atributo que poderá ser herdado por outras classes. Este atributo também já estará anotado com as configurações da JPA e o seu `get()` e `set()`, aumentando com isso o reaproveitamento do código:

```java
@MappedSuperclass
public class AbstractEntity {

 @Id
 @GeneratedValue
 private Long id;

 // get e set

}
```

Esta classe servirá de base para todos os modelos do sistema. Logo, devemos fazer com que os models herdem essa classe. Assim, o atributo `id` e seus respectivos `get()` e `set()` não precisarão ser repetidos em todos os modelos criados, pois agora iremos recebê-los da entidade AbstractEntity através da herança. Nesta classe poderá ser adicionado qualquer código que necessite ser comum às entidades como, por exmeplo, o `hashCode()` e `equals()`. Veja um exemplo a seguir como a entidade Usuario receberia estes valores por herança:

```java
public class Usuario extends AbstractEntity {

}
```

É preciso observar que a entidade abstrata só servirá para herança, por isso, no lugar do `@Entity`, esta classe É anotada com `@MappedSuperclass`. Essa anotação diz para o Hibernate que a classe não será uma entidade que terá uma representação no banco em forma de tabela, sendo apenas uma superclasse.

### Generics

A classe genérica é aquela que não recebe ou manipula um tipo exato, ou seja, ela tem a capacidade de trabalhar com vários tipos de classes diferentes. O nosso sistema possuirá a classe GenericBusiness, que manterá o CRUD base. Esta classe não irá manipular um model específico, mas sim o que indicarmos, por isso ela é genérica. Assim, todas as outras classes de negócios que dependam de alguma ação do CRUD deverá herdá-la para obter estes métodos prontos. No código a seguir temos um trecho dessa classe genérica que em sua declaração recebe o tipo do modelo a ser manipulado:

```java
public abstract class GenericBusiness<T extends AbstractEntity> {

 protected EntityManager manager;
 protected Class<T> clazz;

 ...

}
```

Recebemos um argumento genérico `T` para indicar e manter o tipo da classe manipulada no momento. Veja que só são aceitas classes que estendem `AbstractEntity`, ou seja, deve ser uma entidade que obrigatoriamente tenha o atributo `id`, deixando nossa estrutura um pouco menos sussetível a erros.

A classe GenericBusiness precisará do `EntityManager` e de um atributo do tipo `Class`, que servirá para manter o tipo da classe recebida através do argumento genérico `T`. Esta classe a ser manipulada será capturada no construtor da classe genérica, como mostrado a seguir:

```java
protected GenericBusiness(EntityManager manager) {
 this.manager = manager;
 this.clazz = (Class<T>)
  ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];
}
```

Através da classe atual, GenericBusiness, o tipo genérico é recuperado e convertido para o tipo parametrizado. Com isso o método `getActualTypeArguments()` recupera a lista dos argumentos e devolve apenas o primeiro por meio de seu índice `[0]`, que é exatamente o tipo genérico. Por fim, este tipo genérico é convertido em um `Class` para que possamos saber qual classe a nossa classe genérica irá manipular. Quanto ao `manager`, continua com a sua injeção normalmente, porém não precisaremos injetá-lo em cada uma das camada de negócios que forem existir no sistema, pois ele também será herdado.

Como o tipo da classe é dinâmico, será utilizado o argumento genérico `T` para representar o modelo e o atributo `clazz` para representar a classe desse modelo, pois tanto o tipo quanto a classe serão capturados em tempo de execução. Dessa forma, criaríamos o método `remove()` da seguinte forma:

```java
public void remove(T entity) {
 manager.remove(manager.getReference(clazz, entity.getId()));
}
```

E onde deveria ser passado a classe da entidade, será passado o atributo `clazz`. Em uma HQL que tenha o nome do modelo a ser manipulado, escrito estaticamente, agora terá este nome capturado a partir do atributo `clazz`, como visto a seguir:

```java
manager.createQuery("from " + clazz.getName());
```

Deste modo não importa qual modelo será tratado, pois a classe genérica é inteligente o suficiente para montar os métodos CRUD para cada um deles. Com isso, evitamos a criação destes métodos em cada camada de negócio de um determinado modelo, bastando que estas camadas estendam a classe genérica para receber esses métodos prontos.

### Repository

Hoje em dia há vários padrões disponíveis para melhorar a saúde do projeto. Um deles é o Repository, no qual trabalhamos em cima de interfaces e não mais diretamente com a implementação da lógica. Quando o sistema está voltado à interface, as injeções das camadas de negócios são substituídas por suas respectivas interfaces.

Digamos que temos a camada de negócios UsuarioBusiness, logo deveríamos uma interface para os métodos contidos nessa classe. No Eclipse há uma opção de refatoração que gera uma interface baseada em uma classe com métodos concretos de forma automática. Utilizando esta refatoração, a primeira interface a ser extraída será a do CRUD genérico que acabamos de criar. Este processo pode ser realizado através dos seguintes passos:

+ Abra a classe GenericBusiness;
+ Clique com o botão direito em qualquer lugar do código;
+ Selecione a opção *Refactor > Extract Interface*;
+ Dê o nome de GenericRepository;
+ Clique em *Select All* para selecionar todos os métodos;
+ Desmarque a opção *Generate method comments* e clique em Ok.

Com isso o Eclipse irá rastrear todos os métodos dessa classe e criar uma interface contendo a assinatura de cada um deles, como demonstrado a seguir.

```java
public interface GenericRepository<T extends AbstractEntity> {

 public abstract Collection<T> all() throws Exception;
 public abstract T find(Long id) throws Exception;
 public abstract void remove(T entity) throws Exception;
 public abstract T save(T entity) throws Exception;

}
```

Esta interface poderia ser criada manualmente, mas é mais seguro e rápido deixar o Eclipse fazer este trabalho. Note que as assinaturas são geradas com os modificadores `public abstract`. No entanto, como toda interface já é pública e abstrata por padrão, eles podem ser removidos. O Eclipse também já declara, na GenericBusiness, a implementação que ela deverá fazer. Repare no código a seguir que na declaração da implementação também é passado o tipo genérico `T` da classe, já que este tipo também deve ser declarado na interface criada:

```java
public abstract class GenericBusiness<T extends AbstractEntity> implements GenericRepository<T>
```

Agora esta camada de negócio genérica está assinando um contrato, ou seja, ela tem que implementar os métodos de sua interface. Contudo, vale a pena destacar que a aplicação não dependerá somente dos métodos CRUD. Lembre-se também que existem métodos específicos de cada entidade. Deste modo, além desta interface criada, é necessária a criação das interfaces de cada camada de negócio, como é o caso de UsuarioBusiness, que terá a seguinte interface:

```java
public interface UsuarioRepository {

}
```

Assim, quando houver algum método além do CRUD para a entidade Usuario, a assinatura deste método deverá ser incluída na interface UsuarioRepository. O código a seguir mostra como ficará a camada de negócio UsuarioBusiness:

```java
@Component
public class UsuarioBusiness implements UsuarioRepository {

}
```

A partir deste ponto, em nosso controller, será injetado o repositório em vez da camada de negócio. Com isso é preciso ter atenção, pois o repositório do usuário não tem nenhum método para ser implementado, porém precisamos no mínimo dos métodos CRUD. Então, para conseguirmos os métodos CRUD devemos fazer com que o repositório da camada de negócio estenda o repositório GenericRepository, conforme o código:

```java
public interface UsuarioRepository extends GenericRepository<Usuario> {

}
```

Veja que na declaração do repositório genérico é passado o tipo da classe a ser manipulada. Neste caso, a classe Usuario. Dessa forma, todos os tipos genéricos T serão substituídos por esse tipo.
Como o repositório de usuário agora possui as assinaturas dos métodos CRUD por estender o repositório genérico, a camada de negócio UsuarioBusiness ficará responsável por implementar estes métodos. Como já deixamos nossa arquitetura bem definida, possuímos uma classe com estas implementações, a GenericBusiness. Portanto, ao invés de implementarmos estes métodos na camada de negócios do usuário, basta que esta camada estenda a camada genérica:

```java
@Component
public class UsuarioBusiness extends GenericBusiness<Usuario> implements UsuarioRepository {

 protected UsuarioBusiness(EntityManager manager) {
  super(manager);
 }

}
```

Note que agora estamos usando o construtor da camada de negócio do usuário para passar o `EntityManager` para a classe pai, que neste caso é a classe GenericBusiness. Esta classe genérica agora é responsável por fazer a injeção deste objeto e disponibilizá-lo para qualquer outra classe que herdá-la. Com o repositório criado, certifique-se de injetar as interfaces no lugar das camadas de negócios e o sistema já estará voltado à interface. Desta forma tornamos possível a integração de alguns frameworks que trabalham em cima de interface ou da troca de implementação sem quebrar a compatibilidade do sistema. E com isso teremos uma camada preparada para exposição dos métodos para acesso externo à aplicação, onde o cliente só se preocupará com o que o método faz e não mais com o modo que ele faz. Veja no código a seguir a injeção do nosso repositório no controller do usuário:

```java
private UsuarioRepository repository;

public UsuarioController(UsuarioRepository repository) {
 this.repository = repository;
}
```

Por fim o nosso GenericBusiness ficaria assim:

```java
public abstract class GenericBusiness<T extends AbstractEntity> implements GenericRepository<T> {

  protected final EntityManager manager;
  private final Class<T> clazz;

  protected GenericBusiness(EntityManager manager) {
  this.manager = manager;

  @SuppressWarnings("unchecked")
  Class<T> clazz = (Class<T>)
  ((ParameterizedType) getClass().getGenericSuperclass()).getActualTypeArguments()[0];

  this.clazz = clazz;
  }

  public Collection<T> all() {
  Query query = manager.createQuery("from " + clazz.getName());

  @SuppressWarnings("unchecked")
  Collection<T> list = query.getResultList();

  return list;
  }

  public T find(Long id) {
  return manager.find(clazz, id);
  }

  public void remove(T entity) {
  manager.remove(manager.getReference(clazz, entity.getId()));
  }

  public T save(T entity) throws CommonException {
  return manager.merge(entity);
  }

}
```

Agora conseguimos abstrair boa parte do nosso código deixando de lado as preocupações triviais de um sistema. Há também outras formas de tornar o seu código mais reaproveitável nas views utilizando o [Sitemesh](www.wbotelhos.com.br/2010/07/01/criando-template-com-sitemesh) para trabalhar com templates e o [prelude](http://www.wbotelhos.com.br/2011/04/18/reaproveitando-codigo-com-o-prelude) injetar códigos nas páginas.

Essas implementações estão disponíveis no [VRaptor Starting Project](http://github.com/wbotelhos/vraptor-starting-project) no sentido de otimizar o seu tempo nas tarefas mais comuns de início de projeto.

### Link do projeto:
[http://github.com/wbotelhos/vraptor-starting-project](http://github.com/wbotelhos/vraptor-starting-project)
