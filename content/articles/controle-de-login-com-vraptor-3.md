---
date: 2010-04-07T00:00:00-03:00
description: "Controle de Login com VRaptor 3"
tags: ["java", "vraptor", "login"]
title: "Controle de Login com VRaptor 3"
---

**Atualizado em 17 de Setembro de 2011.**

Vamos abordar um assunto que todo desenvolvedor em algum momento irá precisar: **controle de login**. Hoje em dia é normal você acessar um sistema e lá estar uma telinha para ser digitado o nome de usuário e senha.

Por tempos achei complicado trabalhar com login em uma aplicação [JSP](http://pt.wikipedia.org/wiki/JavaServer_Pages) / [Servlet](http://pt.wikipedia.org/wiki/Servlet) pura, ou criar filtros e mais filtros, mas estou pra dizer que se você já passou por isso, irá ficar satisfeito com o **VRaptor** e seus Interceptadores. (:

### Objetivo:

Criar uma tela de autenticação e uma página de boas vindas disponível apenas para usuários logados.

Precisamos de ter nossa JPA configurada para acesso ao banco de dados. Se você ainda não sabe como fazer isso, da uma passadinha no artigo [JPA e VRaptor 3](http://www.wbotelhos.com.br/2010/02/23/jpa-e-vraptor-3).

**Criando a classe Usuario:**

```java
@Entity
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String email;
    private String senha;

    // getters e setters

}
```

Dissemos que a classe `Usuario` é uma entidade que deverá ser mapeada no banco e o atributo `id` será a chave primária com o seu incremento feito pelo próprio banco de dados. Iremos utilizar o `email` como identificação do usuário junto com a sua respectiva `senha`.

### Criando a classe UsuarioBusiness:

```java
private EntityManager manager;

    public UsuarioBusiness(EntityManager manager) {
        this.manager = manager;
    }

    public Usuario autenticar(String email, String senha) {
        try {
            Query query = manager.createQuery("from Usuario where email = :email and senha = :senha");
            query.setParameter("email", email);
            query.setParameter("senha", senha);
            return (Usuario) query.getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
}
```

Fizemos uma consulta procurando um registro que tenha um e-mail e senha igual ao digitado pelo usuário. Se for encontrado alguma ocorrência, este usuário é retornado, caso contrário um valor nulo será.

Vamos criar uma classe com escopo de sessão para mantermos o nosso usuário.

### Criando a classe UserSession:

```java
@Component
@SessionScoped
public class UserSession {

    private Usuario user;

    public boolean isLogged() {
        return user != null;
    }

    public void logout() {
        user = null;
    }

    // get e set

}
```

Este componente servirá para manter o usuário na sessão, por isso ele deve ser anotado com `@SessionScoped` e como de costume o `@Component` por também se tratar de um componente. Criamos um método que verifica se o usuário esta na sessão, ou seja, é diferente de nulo e outro método para retirar o usuário da sessão, que neste caso é o logout.

Agora precisamos identificar os métodos que são protegidos por login e os que são públicos. Por isso iremos criar uma annotation para indicar os método públicos chamada `@Public`.

> Não se assuste se nunca tiver criado uma [annotation](http://pt.wikipedia.org/wiki/Annotation_%28java%29) em sua vida, muitos desenvolvedores, mesmos os mais experiêntes ainda não tiveram esta oportunidade.

### Criando a anotação pública (Public.java):

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.TYPE, ElementType.METHOD })
public @interface Public {

}
```

Para criarmos uma anotação utilizamos o modificador `@interface`. Além disso anotamos esta classe com uma `@Retention` para especificar qual será a política de retenção. Neste caso utilizaremos a `RetentionPolicy.RUNTIME`, que nos disponibiliza as informações em tempo de execução. Outra anotação importante para utilizarmos é a `@Target`, que configuramos onde esta anotação de permissão poderá ser utilizada, que em nosso caso será em classes (`TYPE`) e métodos (`METHOD`).

> Para aprender um pouco mais sobre annotation você pode ler o artigo ["Trabalhando com Annotations em Java"](http://www.franciscosouza.net/2009/11/05/trabalhando-com-annotations-em-java) do nosso amigo [Francisco Souza](http://twitter.com/franciscosouza). (:

Com isso podemos utilizar anotações em classes e métodos de forma simples para indicar que tais recursos poderão ser utilizados sem que o usuário esta logado.

Precisamos de uma página para o usuário digitar o e-mail e senha.

### Criando a página de Login (login.jsp):

```jsp
<form action="${pageContext.request.contextPath}/autenticar" method="post">
    E-mail: <input type="text" name="usuario.email"/>
    Senha: <input type="password" name="usuario.senha"/>
    <input type="submit" value="Acessar"/>
</form>
```

Temos um formulário que submete o e-mail e senha para um método do `LoginController` que por sua vez fará a autenticação.

### Criando a classe LoginController:

```java
@Resource
public class LoginController {

    private Result result;
    private UserSession userSession;
    private UsuarioBusiness business;

    public LoginController(Result result, UserSession userSession, UsuarioBusiness business) {
        this.result = result;
        this.userSession = userSession;
        this.business = business;
    }

    @Public
    @Get("/login")
    public void login() {

    }

    @Public
    @Post("/autenticar")
    public void autenticar(Usuario usuario) {
        Usuario user = business.autenticar(usuario.getEmail(), usuario.getSenha());

        if (user != null) {
            userSession.setUser(user);

            result.redirectTo(IndexController.class).index();
        } else {
            result.include("error", "E-mail ou senha incorreta!").redirectTo(this).login();
        }
    }

    @Get("/logout")
    public void logout() {
        userSession.logout();
        result.redirectTo(this).login();
    }

}
```

Nosso controller tem três métodos:
- O `@Get /login` apenas nos leva para a página de autenticação;
- O `@Post /autenticar` é o método que recebe o e-mail e senha do formulário e faz a consulta no banco. Se o usuário existir, então este é colocado na sessão e redirecionado para dentro do sistema; e
- O `/logout` desloga o usuário colocando um valor nulo na sessão e o redireciona para a página de login.

Repare que o método que leva à página de login e o método para autenticação estão anotados com `@Public`, isso evitará que o sistema faça o bloqueio do recurso, já que o usuário necessita dessas ações para se autenticar. Já o método logout, apenas quem esta logado poderá ter acesso a ele.

### Criando o IndexController:

```java
@Resource
public class IndexController {

    @Get("/")
    public void index() {
    }

}
```

Temos apenas um método para nos redirecionar para a página inicial interna do sistema. Sendo que este controller não possibilita acesso público.

### Criando a página inicial (index.jsp):

Nossa página inicial terá apenas uma mensagem de boas vindas ao usuário logado que estará na sessão e um link para ser desfeito o login (logout).

```jsp
...
Olá, ${userSession.user.nome} <a href="${pageContext.request.contextPath}/logout">Logout
...
```

Com isso terminamos a parte um pouco mais trabalhosa que já estamos acostumados a fazer, sobrando a cereja do bolo, a qual será de fato o controle e restrição de acesso ao sistema.

Todo esse controle será feito por uma classe chamada de [Interceptor](http://vraptor.caelum.com.br/documentacao/interceptadores), na qual irá interceptar todas ações efetuadas no sistema fazendo uma auditoria que de acordo com sua regra tomará uma atitude.

Criaremos esta classe que estenderá `Interceptor` e receberá injetado o `UserSession` para nos disponibilizar o usuário da sessão.

Esta classe deve ser anotada com `@Intercepts` para conseguir interceptar as chamadas.

### Criando a classe LoginInterceptor:

```java
@Intercepts
public class LoginInterceptor implements Interceptor {

    private Result result;
    private UserSession userSession;

    public LoginInterceptor(Result result, UserSession userSession) {
        this.result = result;
        this.userSession = userSession;
    }

    public boolean accepts(ResourceMethod method) {
        return
            !(method.getMethod().isAnnotationPresent(Public.class) ||
            method.getResource().getType().isAnnotationPresent(Public.class));
    }

    public void intercept(InterceptorStack stack, ResourceMethod method, Object resourceInstance) {
        if (userSession.isLogged()) {
            stack.next(method, resourceInstance);
        } else {
            result.redirectTo(LoginController.class).login();
        }
    }

}
```

Todo interceptor tem um método `accepts` no qual podemos fazer regras para indicar se o recurso acesso será ou não interceptado. Nós já pensamos em uma forma de excluir alguns recursos do filtro do interceptor através da anotação `@Public`. Logo verificamos se o método ou o controller esta anotado com ela, se estiver será retornado `true`, então negamos o resultado para `false` dizendo: "Não aceitamos a interceptação desta ação!". Aqui pode entrar qualquer regra que lhe convenha.

Caso o recurso seja interceptado, o método `intercept` irá ser executado para o tratamento. Este método recebe como argumento um `InterceptorStack` que será responsável por dar continuidade ao fluxo da execução através do método `next`. Há também outros dois argumentos que serão discutidos em outro artigo e não são necessárias por hora. Repare que capturamos a sessão e verificamos se o usuário esta logado, através do método que criarmos no componente, dando continuidade ao fluxo, caso contrário é feito um redirecionamento para a página de login para que o usuário se autentique.

Ok! Nosso controle de login esta pronto, e cá pra nós: se você souber um jeito mais fácil de fazer isso em Java, por favor, me mostre como é que eu te pago um saquinho de jujubas. (;

### Link do projeto

[http://github.com/wbotelhos/controle-login-vraptor-3](http://github.com/wbotelhos/controle-login-vraptor-3)
