---
date: 2011-12-06T00:00:00-03:00
description: "Hibernate - Relacionamento ManyToMany Com Atributos"
tags: ["hibernate", "manytomany", "attributos", "java"]
title: "Hibernate - Relacionamento ManyToMany Com Atributos"
---

Neste post será mostrado como utilizar o relacionamento ManyToMany do Hibernate com uma maior autonomia de alteração da tabela intermediária. Sendo assim teremos um pouquinho mais de trabalho, porém uma maior flexibilidade. Se você não esta familiarizado com o Hibernate, recomendo a leitura do post [Hibernate – Relacionamento ManyToMany Sem Atributos](http://www.wbotelhos.com.br/2011/11/06/hibernate-relacionamento-manytomany-sem-atributos), pois este post esta sendo tratado com uma evolução do anterior.

### Objetivo:

Utilizando o Hibernate, será mostrado como criar uma tabela intermediária que possui atributos e estado em um relacionamento ManyToMany.

### Cenário:

Teremos as entidades Filme e Artista, onde podemos ter um filme com vários artistas e um artista poderá estar em vários filmes, sendo que o artista terá diferentes nomes em cada um destes filmes.

### Análise:

<img src="http://farm9.staticflickr.com/8155/7688784170_ae426a4c8c.jpg" alt="Filme x Artista" title="Filme x Artista" width="455" height="116" class="align-center" />

A princípio temos a tabela Filme tendo vários artistas e a tabela Artista tendo vários filmes. Logo será necessário criar a tabela intermediária ArtistaFilme. Também precisamos de achar um lugar para mantermos o nome artístico do artista. Mas onde?

<img src="http://farm8.staticflickr.com/7262/7688784378_04de9ce6ac.jpg" alt="Filme x Artista x ArtistaFilme" title="Filme x Artista x ArtistaFilme" width="472" height="279" class="align-center" />

Bem, aqui temos a nossa já conhecida tabela intermediária e como tínhamos de achar um lugar para o nome do artista para um filme específico, nada mais justo que deixar na tabela intermediária. Assim aquele nome só será válido para um artista em um determinado filme.

O que não tínhamos visto ainda era essa tabela intermediária com ID e muito menos outros atributos. O atributo nome já sabemos que era necessário isolá-lo lá para ser exclusivo do relacionamento, mas e o ID? Bem se essa tabela tem um ID ela possui estado, ou seja, ela é salva, consultada, alterada e removida, não apenas uma tabela automática para manter os relacionamentos. E como fazer o Hibernate criar essa tabela pra mim? Como diz meu amigo **Bruno Oliveira** ([AbstractJ](http://twitter.com/abstractj)): não repita essa pergunta alto.

Perceba que o relacionamento no final das contas fica (Filme 1 -- * ArtistaFilme) e (Artist 1 -- * ArtistaFilme), além disso a tabela ArtistaFilme possui estado. Tá, vou deixar você falar a solução: "Putz, isso ai é um OneToMany no Filme e no Artista!". :D

Pois é, agora basta tratarmos a tabela intermediária como uma entidade da nossa aplicação e fazermos os relacionamentos:

### Filme.java

```java
@Entity
public class Filme {

  @Id
  @GeneratedValue
  private Long id;
  private String nome;

  @OneToMany(mappedBy = "filme", cascade = CascadeType.ALL)
  private Collection<ArtistaFilme> artistaFilmeList;

  // getters e setters

}
```

Agora em vez de pensarmos que o filme terá vários artistas, iremos pensar que ele terá um elenco, ou seja, uma lista de ArtistaFilme. Pra isso utilizamos o `@OneToMany` que deverá estar como `CascadeType.ALL` para que quando salvarmos, atualizarmos ou removermos o filme, também seja feita esta alterações na tabela ArtistaFilme.

Como o OneToMany é a parte fraca do relacionamento por não possuir a chave estrangeira (*Foreing Key*), precisamos dizer como ele será vinculado à outra tabela. Para isso utilizamos o `mappedBy` com o nome do atributo da tabela ArtistaFilme que representará ele como objeto, que no banco será a chave estrangeira.

### Artista.java

```java
@Entity
public class Artista {

  @Id
  @GeneratedValue
  private Long id;
  private String nome;

  @OneToMany(mappedBy = "artista", cascade = CascadeType.ALL)
  private Collection<ArtistaFilme> artistaFilmeList;

  // getters e setters

}
```

Sem muitos segredos, a entidade Artista utilizará as mesma configurações da entidade Filme, trocando apenas o nome do atributo que o representará na tabela ArtistaFilme, que neste caso será "artista".

### ArtistaFilme.java

```java
@Entity
public class ArtistaFilme {

  @Id
  @GeneratedValue
  private Long id;
  private String nome;

  @ManyToOne
  @JoinColumn(name = "filme_id")
  private Filme filme;

  @ManyToOne
  @JoinColumn(name = "artista_id")
  private Artista artista;

  // getters e setters

}
```

Nesta tabela intermediária teremos o ID, já que agora ela possui estado e temos o nome dado ao artista no terminado filme. Filmes este, que esta representado pelo objeto "filme" que possui o relacionamento ManyToOne, pois ele será chave estrangeira (FK) nessa tabela. Como já conhecemos, utilizamos a anotação @JoinColumn para dar um nome bonito para a nossa FK.

Da mesma forma temos o objeto "artista" também representado a FK do Artista formando a identificação completa do relacionamento: um artista estréia em um filme com um determinado nome. Veja um exemplo a seguir de como seria o código para salvar um filme com dois artistas em seu elenco.

```java
public static void main(String[] args) {
  EntityManager manager = JPAHelper.getEntityManager();

  Artista artista1 = new Artista();
  artista1.setNome("artista-1");
  artista1 = manager.merge(artista1);

  Artista artista2 = new Artista();
  artista2.setNome("artista-2");
  artista2 = manager.merge(artista2);

  Filme filme = new Filme();
  filme.setNome("filme");

  ArtistaFilme artistaFilme1 = new ArtistaFilme();
  artistaFilme1.setFilme(filme); // Referencia de memoria.
  artistaFilme1.setArtista(artista1);
  artistaFilme1.setNome("nome-artistico-1");

  ArtistaFilme artistaFilme2 = new ArtistaFilme();
  artistaFilme2.setFilme(filme); // Referencia de memoria.
  artistaFilme2.setArtista(artista2);
  artistaFilme2.setNome("nome-artistico-2");

  Collection<ArtistaFilme> elenco = Arrays.asList(artistaFilme1, artistaFilme2);

  filme.setArtistaFilmeList(elenco);

  manager.merge(filme);

  JPAHelper.close();
}
```

Neste código acima criamos dois artistas e os salvamos. Depois criamos um filme e o deixamos em memória. Em seguida criarmos o relacionamento entre o filme e o artista que terá um nome artístico nesta estréia. Pegamos estes dois artistas já relacionados ao filme e os colocamos em uma lista que forma o elenco. Este elenco é setado no filme a ser salvo que através da ação de cascada também salvará o elenco.

Repare que antes mesmo do filme ser salvo já passamos a referência de memória de seu objeto para o objeto ArtistaFilme. O filme ainda não tem chave primária, porém ao ser salvo e gerado sua chave, toda o elenco que será salvo por cacada já estará apontando para este filme. Lembre-se que o Hibernate trabalho orientado a objeto e não a tabela do banco.

<img src="http://farm9.staticflickr.com/8020/7688784272_630e42447c.jpg" alt="Arista x Filme x ArtistaFilme" title="Arista x Filme x ArtistaFilme" width="398" height="151" class="align-center" />

Assim vemos que o filme tem em seu elenco os artista 1 e 2. Deste modo basta alimentar esta lista os mesmos serão salvos na tabela intermediária como elenco.

### Link do projeto:
[http://github.com/wbotelhos/hibernate-manytomany-com-atributos](http://github.com/wbotelhos/hibernate-manytomany-com-atributos)
