---
date: 2011-11-06T00:00:00-03:00
description: "Hibernate - Relacionamento ManyToMany Sem Atributos"
tags: ["hibernate", "java", "manytomany"]
title: "Hibernate - Relacionamento ManyToMany Sem Atributos"
---

Para aqueles que trabalham com Java, é quase que improvável a não utilização do framework de persitência [Hibernate](http://en.wikipedia.org/wiki/Hibernate_%28Java%29). Sabemos que ele é muito poderoso e trabalha de diversas formas, por isso irei mostrar, neste primeiro de 3 artigos, como trabalhar com um relacionamento que atormenta muitos desenvolvedores, o **ManyToMany**.

### Objetivo:

Utilizando o Hibernate, será mostrado uma forma simples de criar uma tabela intermediária em um relacionamento ManyToMany que não possui atributos e estado.

### Cenário:

Teremos uma tabela Perfil e uma tabela Acesso, onde poderemos ter um perfil com vários acessos e um acesso poderá estar em vários perfis.

### Análise:

Quando estamos fazendo o nosso diagrama de classe e temos uma entidade A que pode estar relacionada a várias entidades B e esta entidade B pode estar relacionada a várias entidades A, temos um relacionamento muitos para muitos:

<img src="http://farm9.staticflickr.com/8155/7688512464_c60cd16c9d.jpg" alt="ManyToMany Simples" title="ManyToMany Simples" width="443" height="125" class="align-center" />

Este relacionamento requer uma nova entidade para representar uma tabela intermediária para manter o(s) relacionamento(s) da(s) chave(s) da entidade A com a(s) chave(s) da entidade B.

<img src="http://farm9.staticflickr.com/8167/7688512626_30c74f0487.jpg" alt="ManyToMany Full" title="ManyToMany Full" width="463" height="283" class="align-center" />

### Solução:

Reparem que a tabela intermediária AcessoPerfil não possui nada além das chaves estrangeiras da tabela Perfil e Acesso, ou seja, ela não possui estado já que nem agregaria valor pra gente manipula-lá diretamente. Sendo assim ela só sevirá para armazenar os relacionamentos. Com isso uma [surrogate key](http://en.wikipedia.org/wiki/Surrogate_key) (Chave Primária) se faz necessária neste caso.

Agora vamos criar as entidades para representar estas tabelas e seus relacionamentos.

### Acesso.java

```java
@Entity
public class Acesso {

 @Id
 @GeneratedValue
 private Long id;
 private String nome;

 // getters e setters

}
```

A entidade Acesso é bem simples, possuindo um nome e uma chave primária gerada automáticamente pelo banco.

### Perfil.java

```java
@Entity
public class Perfil {

 @Id
 @GeneratedValue
 private Long id;
 private String nome;

 @ManyToMany(cascade = { CascadeType.PERSIST, CascadeType.MERGE })
 @JoinTable(
  name = "AcessoPerfil",
  joinColumns = @JoinColumn(name = "perfil_id"), inverseJoinColumns = @JoinColumn(name = "acesso_id")
 )
 private Collection<Acesso> acessoList;

 // getters e setters

}
```

No Perfil também temos um nome e uma chave primária gerada pelo banco, porém também possui uma lista de Acessos, já que um perfil **TEM** vários acessos. É bem simples deduzir que aqui é o lugar da lista, mas podemos nos confundir na hora do mapeamento do Hibernate.

O [erro](https://hibernate.onjira.com/browse/HHH-3410 "@OneToMany forces unique key in @JoinTable") mais comum é pensarmos no `@OneToMany`, já que um perfil tem vários acesso. Não podemos anotar esta lista assim, pois se pensarmos na nossa necessidade contrária, um acesso deve poder pertencer a vários perfis. Este erro fica mais claro quando tentamos salvar dois perfis distintos relacionado a um mesmo acesso, já que recebemos um erro do Hibernate dizendo que o código do acesso não é único na tabela intermediária, ou seja, `acesso_id` esta configurado como `unique`. E é assim que deveria ser, mesmo você querendo salvar vários acessos para **um** perfil. Veja que se você deixar um acesso pertencer a mais de um perfil, o relacionamento inverso (Acesso -> Perfil) deixará de ser `@ManyToOne`, já que ele estará ligado a mais de um perfil, e passará a ser `@OneToMany`. Oras, se precisamos de um relacionamento *um para muitos* em ambos os lados devemos utilizar o `@ManyToMany` para que seja criada a tabela intermediária para manter os relacionamentos das chaves e ai sim poderemos ter vários perfis relacionados a vários acessos e vice-verso.

O `@ManyToMany` deve estar configurado com `cascade` para `PERSIST` e `MERGE` que são as ações de salvar e atualizar, pois assim é possível o Hibernate salvar o Perfil e em uma ação cascateada salvar cada item da lista de acesso, que em nível de tabela é representado por uma chave na tabela intermediária. Não se preocupe com o `REMOVE` e os *orphans*, pois isso já é manipulado automáticamente.

O legal desse relacionamento many-to-many sem atributos é que não precisamos criar a tabela intermediária explícitamente, pois o Hibernate já cuida disso pra gente. Mas e se eu quisesse personalizar os nomes das FKs (Foreing Keys) e o nome da tabela? Bem, isso é possível através da anotação `@JoinTable` que possui um parâmetro chamado `name` no qual indica o nome da tabela a ser criada, que demos o nome de **AcessoPerfil**. Além disso podemos dar nome aos campos das FKs através de um outro atributo chamado `joinColumns`, que será o nome da coluna da tabela principal (Perfil), na qual você esta fazendo a anotação, e o atributo `inverseJoinColumns` que será o nome da chave da tabela secundária (Acesso). Temos um único detalhe na hora de dar o nome, que em vez de usarmos `= "nome"`, precisamos de uma anotação para encapsular este nome chamada de `@JoinColumn` que também possui o atributo `name`. Sendo assim damos o nome da seguinte forma: `= @JoinColumn(name = "nome")`.

Veja um exemplo de como seria o código para salvar dois perfis distintos onde ambos teriam os dois mesmos tipos de acessos.

### Programa.java

```java
public static void main(String[] args) {
  EntityManager manager = JPAHelper.getEntityManager();

  Acesso acesso1 = new Acesso();
  acesso1.setNome("acesso-1");
  acesso1 = manager.merge(acesso1);

  Acesso acesso2 = new Acesso();
  acesso2.setNome("acesso-2");
  acesso2 = manager.merge(acesso2);

  Collection<Acesso> acessoList = Arrays.asList(acesso1, acesso2);

  Perfil perfil1 = new Perfil();
  perfil1.setNome("perfil-1");
  perfil1.setAcessoList(acessoList);
  manager.merge(perfil1);

  Perfil perfil2 = new Perfil();
  perfil2.setNome("perfil-2");
  perfil2.setAcessoList(acessoList);
  manager.merge(perfil2);

  JPAHelper.close();
}
```

Neste código acima criamos dois acessos e os salvamos gerando as chaves número 1 e 2 na tabela Acesso. Em seguida colocamos esses dois acessos em uma lista para vinculá-la aos perfis. Então criamos dois perfis e dissemos que cada um deles estará relacionado com os dois acessos criados. Ao salvarmos os perfils teremos o seguinte resultado:

<img src="http://farm9.staticflickr.com/8166/7688512706_8908bb8a10.jpg" alt="ManyToMany Table" title="ManyToMany Table" width="350" height="200" class="align-center" />

Assim vemos que o perfil 1 tem o acesso 1 e 2, assim como o perfil 2 também possui o acesso 1 e 2. Deste modo basta alimentar a lista de acesso do perfil e o salvar que a propagação do relacionamento da tabela intermediária será automático.

### Link do projeto:
[http://github.com/wbotelhos/hibernate-manytomany-sem-atributos](http://github.com/wbotelhos/hibernate-manytomany-sem-atributos)
