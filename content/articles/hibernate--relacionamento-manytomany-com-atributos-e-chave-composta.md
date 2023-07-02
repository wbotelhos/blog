---
date: 2012-01-17T00:00:00-03:00
description: "Hibernate – Relacionamento ManyToMany Com Atributos e Chave Composta"
tags: ["hibernate", "java", "manytomany", "chave", "composta"]
title: "Hibernate – Relacionamento ManyToMany Com Atributos e Chave Composta"
---

Neste último post da série de relacionamentos ManyToMany iremos explorar um pouco mais o poder do Hibernate. Desta vez iremos utilizar chave composta na tabela intermediária, além dos atributos próprio da tabela. Antes de ler este post recomendo a leitura dos anteriores: [Hibernate – Relacionamento ManyToMany Sem Atributos](http://www.wbotelhos.com.br/2011/11/06/hibernate-relacionamento-manytomany-sem-atributos) e o [Hibernate – Relacionamento ManyToMany Com Atributos](http://www.wbotelhos.com.br/2011/12/06/hibernate-relacionamento-manytomany-com-atributos).

### Objetivo:

Utilizando o Hibernate, será mostrado como criar uma tabela intermediária com atributos e chave composta. Sendo que estas chaves serão as chaves estrangeiras (*Foreign Key*) das tabelas relacionadas.

### Cenário:

Teremos as entidades Empresa e Usuario, sendo que uma empresa pode ter vários usuários e um usuário pode estar em várias empresas. Porém tendo a observação de que devemos garantir que um usuário nunca se repita para a mesma empresa, além de ser necessário gravar a data de vinculação deste usuário.

### Análise:

<img src="http://farm9.staticflickr.com/8168/7688819282_c66ce13af8.jpg" alt="Empresa x Usuario" title="Empresa x Usuario" width="464" height="104" class="align-center" />

Já estamos acostumados com essa situação e sabemos que isso resultará em uma tabela intermediária. Além disso precisamos dizer a data de vínculo do usuário à empresa, logo devemos colocar essa data na tabela intermediária na qual marca tal vínculo:

<img src="http://farm8.staticflickr.com/7125/7688819456_d100a2b1bc.jpg" alt="Empresa x EmpresaUsuario x Usuario" title="Empresa x EmpresaUsuario x Usuario" width="470" height="269" class="align-center" />

Veja que até aqui fizemos a modelagem da mesma forma que o post passado. Porém temos uma necessidade à mais: garantir que um determinado usuário não tenha mais do que um cadastro na mesma empresa. Se você foi curioso o bastante no post passado para ver o *code complete* da anotação `@JoinColumn`, percebeu que existe o atributo `unique`, que configurado para `true` torna um valor único para tal coluna. Só que esta configuração não servirá pra gente, pois queremos que o código da empresa ou do usuário se repita na coluna do banco, mas não um par específico. Poderíamos ter, por exemplo, o usuário (1) na empresa (1), assim como o usuario (2) na empresa (1), mas não estes mesmos conjuntos novamente. Para garantir que este conjunto seja único no banco precisamos transformar as chaves `usuario_id` e `empresa_id` em chave primária composta ([Composite Key](http://en.wikipedia.org/wiki/Compound_key)).

Como o nome mesmo já diz, uma chave composta se comporta como a chave primária, porém o seu valor é composto por mais de uma coluna do banco, neste caso as FKs, porém você pode adicionar quaisquers campos que desejar. Vejamos como ficará nossas classes:

### Empresa:

```java
@Entity
public class Empresa {

  @Id
  @GeneratedValue
  private Long id;

  private String nome;

  @OneToMany // Segura o mappedBy ai por enquanto. (:
  private Collection<EmpresaUsuario> empresaUsuarioList;

  // hashCode e equals

  // getters e setters

}
```

Não temos nenhuma novidade nesse código, já que temos os dados da empresa e uma lista de valores da tabela intermediária. Quanto a configuração da lista deixaremos para depois. Para esse artigo iremos implementar os métodos [hashCode](http://en.wikipedia.org/wiki/Java_hashCode%28%29) e [equals](http://www.cafeaulait.org/course/week4/37.html) que são métodos que dizem quando um objeto será considerado igual a um outro, neste caso iremos utilizar apenas o `id` para esta afirmação. Não tente criar na mão estes métodos, utilize a opção "Generate hashCode() and equals()..." do menu Source do Eclipse para isso ou de sua IDE preferida.

### Usuário:

```java
@Entity
public class Usuario {

  @Id
  @GeneratedValue
  private Long id;

  private String username;

  @OneToMany // Segura o mappedBy ai por enquanto. (:
  private Collection<EmpresaUsuario> empresaUsuarioList;

  // hashCode e equals

  // getters e setters

}
```

Na entidade do usuário também não temos novidades por enquanto, sendo que também teremos a lista da tabela intermediária. Aqui também iremos configurar mais adiante a lista e teremos o `hashCode` e o `equals` também utilizando o `id` da entidade.

E então temos a entidade da tabela intermediária:

### EmpresaUsuario:

```java
@Entity
public class EmpresaUsuario {

  @ManyToOne
  private Empresa empresa;

  @ManyToOne
  private Usuario usuario;

  private Date dataCadastro;

  // getters e setters

}
```

Nessa entidade, como esperado, possui os relacionamentos naturais das chaves e o atributo para manter a data de cadastro do usuário na empresa. E a princípio o `mappedBy` do usuário e da empresa apontaria para esses objetos, mas vamos aguardar, pois ainda haverá modificações.

> Agora sim Botelho, você acabou de escrever exatamente o que escreveu no artigo passado. ¬¬

Bem, até aqui nós já conhecemos, mas ainda não esta claro a forma de transformar essas duas FKs em chaves compostas. Mas o Hibernate sabe um jeitinho maroto pra fazer isso através na anotação `@Embeddable`. Essa anotação será utilizada em uma classe que manterá apenas os atributos que farão parte da chave. Pra isso iremos criar uma nova classe:

### EmpresaUsuario:

```java
@Embeddable
public class EmpresaUsuarioId implements Serializable {

  @ManyToOne(fetch = FetchType.LAZY)
  private Empresa empresa;

  @ManyToOne(fetch = FetchType.LAZY)
  private Usuario usuario;

  // hashCode e equals

  // getters e setters

}
```

A nossa classe agora recebe um nome sugestivo de ID junto com a anotação `@Embeddable`, que diz que ela é uma classe que pode ser embutida em outra. Oras, não é isso que queremos? A idéia é embutir essa classe na nossa entidade EmpresaUsuario em forma de chave composta. Como nossa chave será as FKs, ai estão elas. Perceba que todas as entidades que formam a chave composta devem implementar `Serializable`, caso contrário seu código nem irá compilar. Além disso, não sendo regra mas de meu gosto, prefiro configurar os objetos como `LAZY` para evitar possíveis CircularReference, já que diferentemente de uma anotação `@OneToMany`, o `@ManyToOne` é `EAGER` por padrão. Veja que essa entidade necessita da implementação do `hashCode` e do `equals` e ai faz sentido termos implementado tais métodos no usuário e na empresa, pois aqui os implementamos usando os objetos na comparação que, no fundo, o que será utilizado é o próprio `hashCode` e `equals` das entidades. Sendo assim podemos pensar em um hash externo utilizando o hash interno. Piorou?

Neste ponto já podemos fazer um refactor e retirar os objetos `usuario` e `empresa` da entidade EmpresaUsuario, já que eles estão na chave composta e como você ai já pensou, iremos declarar essa chave/classe composta no lugar das duas FKs explícitas. E ai que vem a cereja do bolo, pois já temos uma classe que pode ser embutida, mas isso não quer dizer que ela já é ID. Devemos dizer isso para o Hibernate através da anotação `@EmbeddedId` ficando assim:

### EmpresaUsuario:

```java
@Entity
public class EmpresaUsuario {

  @EmbeddedId
  private EmpresaUsuarioId id;

  private Date dataCadastro;

  // getters e setters

}
```

Agora temos o ID composto devidamente declarado e configurado. E ai com as chaves naturais devidamente mapeadas, podemos voltar nas classes Empresa e Usuario e configurar a propriedade `mappedBy` apontando para essas chaves. Se você seguir o relacionamento da Empresa, por exemplo, verá que ela tem uma lista de EmpresaUsuario, porém não temos mais os objetos Empresa e Usuario nessa classe, pois eles foram jogados para dentro da chave composta, então como mapeá-los? Bem, é aqui que você aprende algo legal do Hibernate, pois ele suporta navegação dos objetos no `mappedBy`, ficando da seguinte forma:

```java
@OneToMany(mappedBy = "id.empresa")
private Collection<EmpresaUsuario> empresaUsuarioList;
```

Veja que o atributo/classe `id` nós o temos na entidade EmpresaUsuario, então apenas fizemos a navegação para dentro do mesmo buscando o objeto `empresa`. Da mesma forma devemos fazer na entidade Usuario:

```java
@OneToMany(mappedBy = "id.usuario")
private Collection<EmpresaUsuario> empresaUsuarioList;
```

Pronto! Nossa modelagem já esta pronta para ser utilizada. Veja um exemplo a seguir de como seria a ação de adicionar um usuário à uma empresa:

```java
public static void main(String[] args) {
  EntityManager manager = JPAHelper.getEntityManager();

  Empresa empresa = new Empresa();
  empresa.setNome("Concrete Solutions");
  empresa = manager.merge(empresa);

  Usuario usuario = new Usuario();
  usuario.setUsername("wbotelhos");
  usuario = manager.merge(usuario);

  EmpresaUsuarioId id = new EmpresaUsuarioId();
  id.setEmpresa(empresa);
  id.setUsuario(usuario);

  EmpresaUsuario empresaUsuario = new EmpresaUsuario();
  empresaUsuario.setDataCadastro(new Date());
  empresaUsuario.setId(id);

  manager.merge(empresaUsuario);

  JPAHelper.close();
}
```

Neste código iniciamos criando a empresa e depois o usuário. Com eles salvos os utilizamos para formar a chave composta. Em seguida criamos a tabela intermediária com seus dados e setamos a sua chave composta que na verdade é a classe que acabamos de popular com a empresa e o usuário. Em seguida salvamos essa tabela intermediária para fazer o vínculo entre o usuário e a empresa.

<img src="http://farm9.staticflickr.com/8141/7688819358_ec8b72e7bd.jpg" alt="Banco - Empresa x EmpresaUsuario x Usuario" title="Banco - Empresa x EmpresaUsuario x Usuario" width="406" height="113" class="align-center" />

Visualmente no banco fica muito parecido com o ManyToMany com atributos, porém agora as chaves estrangeiras formam a chave primária desta tabela, por isso se tentarmos inserir novamente um registro do usuário (1) na empresa (1) não iríamos conseguir, pois isto seria considerado um *update* para o Hibernate. Sendo assim não haverá registros repetidos no banco.

Pessoalmente eu não gosto de chave composta e até mesmo os *corers* do Hibernate não recomendam, porém uma hora ou outra acabamos por precisar, seja por estarmos dando manutenção em um sistema legado ou porque precisamos de adicionar integridade no banco por ter mais de um sistema acessando-o e nem todos possuirem regras de validação na camada da aplicação.

### Link do projeto:
[http://github.com/wbotelhos/hibernate-manytomany-com-atributos-e-chave-composta](http://github.com/wbotelhos/hibernate-manytomany-com-atributos-e-chave-composta)
