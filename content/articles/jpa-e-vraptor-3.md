---
date: 2010-02-23T00:00:00-03:00
description: "JPA e VRaptor 3"
tags: ["java", "vraptor", "jpa"]
title: "JPA e VRaptor 3"
---

**Atualizado em 4 de Janeiro de 2011.**

Sabemos que hoje em dia é fundamental termos uma framework de persistência nos poupando o trabalho de criação de tabelas, trocas de chave e afins. Se você quer produtividade e um conjunto incrível de funcionalidades, posso dizer que o [Hibernate](https://www.hibernate.org) é uma ótima escolha.

### Objetivo:

Criar um projeto no qual iremos configurar e utilizar a API [JPA](http://pt.wikipedia.org/wiki/Java_Persistence_API) com controle de transação automatizada junto ao [VRaptor 3](http://vraptor.caelum.com.br).

Começaremos criando um arquivo de configuração para o nosso banco de dados.

### Criando o arquivo de configuração (persistence.xml):

```xml
<?xml version="1.0" encoding="UTF-8"?>

<persistence>
   <persistence-unit name="default">
      <provider>org.hibernate.ejb.HibernatePersistence</provider>

      <properties>
        <property name="hibernate.connection.driver_class" value="com.mysql.jdbc.Driver"/>
        <property name="hibernate.connection.username" value="root"/>
        <property name="hibernate.connection.password" value="root"/>
        <property name="hibernate.connection.url" value="jdbc:mysql://127.0.0.1:3306/banco"/>
        <property name="hibernate.dialect" value="org.hibernate.dialect.MySQLInnoDBDialect"/>

        <property name="hibernate.hbm2ddl.auto" value="update"/>

      </properties>
   </persistence-unit>
</persistence>
```

**Linha 4**: temos uma unidade de persistência chamada **default**;
**Linha 5**: usamos o provider do Hibernate;
**Linha 8**: utilizamos o banco de dados MySQL e seu driver;
**Linha 9-10**: o banco esta com nome de usuário e senha "**root**";
**Linha 11**: conexão localhost, porta padrão 3306 no schema "**banco**";
**Linha 2**: o dialeto usado é o InnoDB do MySQL;
**Linha 14**: usamos o [HBM](https://www.hibernate.org/256.html) para gerar as tabelas de automáticamente de acordo com as entidades anotadas com `@Entity`. O valor **update** adiciona colunas no banco à medida que você adiciona ou altera a entidade, porém não as retira caso deixem de existir.

> É importante ressaltar que deverá ser usado o InnoDB, pois ele é transacional, ou seja, é possível trabalhar com trasações ao contrário do MyISAM.

Nossa configuração esta pronta, porém precisamos de uma classe que utilize estas configurações e possibilite nossa aplicação conectar ao banco.

À princípio criaríamos um `EntityManagerUtil` desta forma:

```java
public class EntityManagerUtil {

    private static EntityManagerFactory emf;

    public static EntityManager getEntityManager() {
        if (emf == null) {
            emf = Persistence.createEntityManagerFactory("default");
        }

        return emf.createEntityManager();
    }

    public static void close() {
        emf.close();
    }

}
```

E em nossos DAOs pegaríamos a conexão da seguinte forma:

```java
@Component
public class UsuarioDao {

    private EntityManager manager = EntityManagerUtil.getEntityManager();
    ...

}
```

Através da nossa classe utilitária seria possível obter o `EntityManager` e assim a `Transaction`, mas teríamos algo indesejado, o **acoplamento**.

Nosso DAO esta se preocupando com a forma de obtê-lo e este código esta amarrado à própria classe. O ideal seria receber este objeto, através de um método `set`, construtor ou [injeção de dependência](http://pt.wikipedia.org/wiki/Inje%C3%A7%C3%A3o_de_depend%C3%AAncia) e é ai que o VRaptor entra para nos ajudar. (:

No lugar dessa classe `EntityManagerUtil` vamos registrar um [componente opcional](http://vraptor.caelum.com.br/documentacao/componentes-utilitarios-opcionais) do VRaptor.

**Criando o componente CustomProvider:**

```java
public class CustomProvider extends SpringProvider {

    @Override
    protected void registerCustomComponents(ComponentRegistry registry) {
        registry.register(EntityManagerCreator.class, EntityManagerCreator.class);
        registry.register(EntityManagerFactoryCreator.class, EntityManagerFactoryCreator.class);
        registry.register(JPATransactionInterceptor.class, JPATransactionInterceptor.class);
    }

}
```

Nossa classe estende `SpringProvider` e sobrescreve o método `registerCustomComponents` para registrar o `EntityManagerCreator`, `FactoryCreator` e `JPATransaction` nos disponibilizando assim o `EntityManager` de forma transparente.

Depois de criar esta classe, devemos registrá-la como um provider no **web.xml**:

```xml
<context-param>
   <param-name>br.com.caelum.vraptor.provider</param-name>
   <param-value>br.com.wbotelhos.provider.CustomProvider</param-value>
</context-param>
```

Usando o nosso provider podemos decidir se iremos registrar o componente de controle de transação ou não. Mas o VRaptor ainda faz mais por nós e como já era esperado que iríamos querer todo estes componentes, o VRaptor já incluiu em seu pacote `util` um outro pacote chamado `jpa` que já registra estes três componentes e que por sua vez substituirá a nossa `CustomProvider` bastando trocar o registro do `web.xml` para apontar para o mesmo:

```xml
<context-param>
    <param-name>br.com.caelum.vraptor.packages</param-name>
    <param-value>br.com.caelum.vraptor.util.jpa</param-value>
</context-param>
```

Agora você pode retirar qualquer `begin` e `commit` do seu código, pois o VRaptor irá se preocupar com isso por você. Quanto ao `rollback` você precisa de mantê-lo, pois se der um erro em alguma operação, todas as anteriores serão desfeita, já que o VRaptor irá manter este conjunto de ações em uma única transação de forma transparente.

Pronto! Agora o VRaptor já sabe que deve buscar e utilizar o nosso `persistence.xml`, que deve estar localizado no [classpath](http://www.guj.com.br/article.show.logic?id=108) dentro de **src/META-INF**.

> O VRaptor por padrão procura por uma persistence-unit chamada "**default**". Certifique-se de ter criado com este nome: `<persistence-unit name="default"` ...

Com isso o DAO recebe por injeção o `EntityManager` evitando o alto acoplamento:

````java
@Component
public class UsuarioDao {

    private EntityManager manager;

    UsuarioDao (EntityManager manager) {
        this.manager = manager;
    }

    ...

}
```

> Procure se possível utilizar um DAO genérico, evitando repetições de código.

### Criando o schema e populando o banco:

Existe um arquivo, `banco.sql`, dentro do projeto já com o código SQL para criar e popular o banco, mas se preferir poderá rodar a aplicação e o Hibernate tratará de criar todo o banco devido ao *SchemaExport (hbm2ddl)*, ficando-lhe apenas a tarefa de populá-lo.

Vamos criar uma entidade `Usuario`:

```java
@Entity
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String email;

    // getters and setters

}
```

Dissemos que `Usuario` é uma entidade e que `id` é a chave, sendo esta incrementada pelo banco.

Com a entidade criada, podemos criar um método para colocarmos o Hibernate em ação:

```java
public Usuario loadByNome(String nome) throws Exception {
    try {
        Query query = manager.createQuery("from Usuario where nome = :nome");
        query.setParameter("nome", nome);
        Usuario usuario = (Usuario) query.getSingleResult();
        return usuario;
    } catch (NoResultException e) {
        throw new Exception("Nenhum resultado!");
    }
}
```

Na consulta acima buscamos pelo nome passado por parâmetro e retornamos um `Usuario`.

> Foi colocado um `rollback` para ilustrar o uso, apesar de não ser necessário neste caso.

Vamos criar o controller para fazer a chamada desse método e disponibilizar o resultado em tela:

```java
@Resource
public class UsuarioController {

    private Result result;
    private UsuarioDao usuarioDao;

    public UsuarioController(Result result, UsuarioDao usuarioDao) {
        this.result = result;
        this.usuarioDao = usuarioDao;
    }

    @Get
    @Path("/usuario/consultar")
    public Usuario consulta(Usuario entity) {
        try {
            return usuarioDao.loadByNome(entity.getNome());
        } catch (Exception e) {
            result.include("message", e.getMessage());
        }
        return null;
    }

}
```

Fizemos a injeção dos recursos que necessitamos e chamamos o método que nos retorna um usuário de acordo com o nome passado.

Por fim iremos criar as páginas de consulta e resultado.

### Página de consulta (index/index.jsp):

```jsp
<form action="<c:url value='/usuario/consultar'/>" method="get">
    Consultar: <input type="text" name="entity.nome"/>
    <input type="submit"/>
</form>
```

**Página de resultado (usuario/resultado.jsp):**

```jsp
${message}

<c:if test="${usuario != null}">
    ID: ${usuario.id}
    Nome: ${usuario.nome}
    E-mail: ${usuario.email}
</c:if>
```

Os [componentes utilitários](http://vraptor.caelum.com.br/documentacao/componentes-utilitarios-opcionais) do VRaptor ainda possui outros recursos como `Hibernate Session` e `SessionFactory`, e creio que cada vez mais irá facilitar nossas vidas.

Quero agradecer a ajuda do [Mário Peixoto](http://mariopeixoto.wordpress.com), que sanou várias dúvidas.

### Link do projeto:

[http://github.com/wbotelhos/jpa-vraptor](http://github.com/wbotelhos/jpa-vraptor-3)
