---
date: 2010-04-23T00:00:00-03:00
description: "Controle de Permissão com VRaptor 3"
tags: ["java", "vraptor", "permission"]
title: "Controle de Permissão com VRaptor 3"
url: "controle-de-permissao-com-vraptor-3"
---

**Atualizado em 17 de Setembro de 2011.**

Em uma aplição com diferentes níveis de acesso à funcionalidades, é fundamental termos controle das ações efetuadas pelos usuários. Podemos citar, por exemplo, exclusão de dados, alteração de informações ou visualização de certas telas que apenas os usuários com privilégio mais alto poderiam executar.

### Objetivo:

Criar funcionalidades de um sistema, nas quais cada uma só poderá ser executada por um determinado tipo de usuário.

### O que será tratado?:
- Controle de acesso a métodos específicos; e
- Controle de acesso a um controller como um todo.

> Recomendo a leitura do artigo [Controle de Login com VRaptor 3](http://wbotelhos.com.br/2010/04/07/controle-de-login-com-vraptor-3), pois introduz o conceito de [http://vraptor.caelum.com.br/documentacao/interceptadores/Interceptor) e explica como criar uma [annotation](http://pt.wikipedia.org/wiki/Annotation_%28java%29).

Quando falamos em permissões, logo pensamos em **perfis**, já que uma permissão estará ligada diretamente a estes. Com isso criaremos um [Enum](http://java.sun.com/j2se/1.5.0/docs/guide/language/enums.html) com alguns nomes de perfil para usarmos como indicadores das permissões.

### Criando os perfis (Perfil.java):

```java
public enum Perfil {

    MEMBRO, MODERADOR, ADMINISTRADOR;

}
```

Veja que temos 3 (três) tipos de perfis, cada um deles poderá ter um privilégio diferente.

### Criando o usuário (Usuario.java):

```java
public class Usuario {

    private Long id;
    private String nome;
    private Perfil perfil;

    // getters e setters

}
```

No objeto usuário, além dos atributos normais que o mesmo possa ter, também teremos o atributo que manterá o perfil do usuário.

### Criando a anotação pública (Public.java):

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.TYPE, ElementType.METHOD })
public @interface Public {

}
```

Esta anotação servirá para indicar que o recurso é público e não possui restrições.

### Criando o controller inicial (IndexController.java):

```java
@Resource
public class IndexController {

    ...

    @Public
    @Get("/")
    public void index() {
       Usuario usuario = new Usuario();
       usuario.setNome("Washington Botelho");
       usuario.setPerfil(Perfil.MODERADOR);

       session.setAttribute("user", usuario);
    }

}
```

No controller de entrada criamos um mock do usuário com tipo de perfil (moderador) já o colocando na sessão para o utilizarmos no exemplo. Em uma aplicação real você pegaria esse usuário do banco de dados quando o mesmo fizesse o login. Repare que este método esta sendo anotado com @Public para indicar que ele não entrará no controle de permissão.

Agora precisamos de criar a camada de negócios que simulará as ações feitas no banco de dados.

### Criando o Business (UsuarioBusiness.java):

```java
@Component
@SessionScoped
public class UsuarioBusiness {

    private Collection<Usuario> manager = new ArrayList<Usuario>();

    public void save(Usuario usuario) {
       manager.add(usuario);
    }

    public void remove(Usuario usuario) {
       manager.remove(usuario);
    }

    public Collection<Usuario> all() {
       return manager;
    }

    // getters e setters

}
```

Esta camada de negócio simula a inserção, remoção e recuperação dos usuários em cima de uma lista que ficará na sessão por conta da classe estar anotada com `@SessionScoped`. Em uma aplicação real você acessaria o banco e não teria esta anotação.

O próximo passo é criar uma anotação para podermos utilizá-las nos métodos e controllers que queremos restringir o acesso. Com esta anotação podemos identificar qual usuário tem direito de acesso ao método ou controller anotado.

### Criando a anotação de permissão (Permission.java):

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.TYPE, ElementType.METHOD })
public @interface Permission {

    Perfil[] value();

}
```

Esta anotação possui um único elemento que é um array de `Perfil` que por ser o único atributo existente nessa anotação, é chamado de `value` por boas práticas. Com isso podemos utilizar anotações em classes e métodos de forma simples. Vejamos um exemplo de um método anotado com a permissão apenas para administrador:

```java
@Permission(Perfil.ADMINISTRADOR)
public void foo() {

}
```

Aqui utilizamos a anotação `Permission` passando o valor de administrador. Quando passamos apenas um valor para a anotação podemos omitir o atributo `value`, que será equivalente a:

```java
@Permission(value = Perfil.ADMINISTRADOR)
```

Caso queira utilizar mais de um valor na anotação deverá passá-la em formato de hash, entre chaves separando os valores por vírgula:

```java
@Permission({ Perfil.ADMINISTRADOR, Perfil.MODERADOR })
```

Com o conceito já maduro de *annotation*, já é possível anotar métodos ou controllers que necessitarem de restrições.

### Criando o controller do usuário (UsuarioController.java):

```java
@Resource
public class UsuarioController {

    ...

    @Get("/usuario")
    public void listagem() {
       return business.all();
    }

    @Post("/usuario")
    @Permission(Perfil.MODERADOR)
    public void salvar(Usuario usuario) {
       business.save(usuario);

       result
       .include("message", "Usuário adicionado com sucesso!")
       .redirectTo(this).listar();
    }

    @Delete("/usuario/{entity.id}")
    @Permission({ Perfil.MODERADOR, Perfil.ADMINISTRADOR })
    public void remover(Usuario usuario) {
       business.remove(usuario);

       result
       .include("notice", "Usuário removido com sucesso!")
       .redirectTo(this).listar();
    }

}
```

Temos 4 (quatro) métodos:
- `listagm` e `negado`: sem anotação. Podem ser acessados livrementes;
- `salvar`: com permissão apenas para moderador.
- `remover`: com permissão para moderador e administrador.

> Lembre-se que em nível de programação os perfis não são cumulativos. Não é porque um usuário é administrador que ele poderá executar ações de um método anotado para membros. Se você quiser acesso para o administrador, deverá adicioná-lo na anotação.

Também criaremos um controller administrativo, no qual todas as funcionalidades contidas nele só poderão ser executadas pelo administrador.

### Criando o controller administrativo (AdminController):

```java
@Resource
@Permission(Perfil.ADMINISTRADOR)
public class AdminController {

}
```

Repare que agora a anotação esta na classe, indicando que o acesso a qualquer método desta só poderá ser feito pelo administrador.

Vamos criar as telas do sistema.

### Criando a página inicial (index.jsp):
```html
...
<a href="${pageContext.request.contextPath}/">Início)
<a href="${pageContext.request.contextPath}/usuario">Listar usuários)
<a href="${pageContext.request.contextPath}/admin">Administração)

Seja bem vindo: ${userSession.user.nome}
...
```

Acima criamos simples os links de navegação do sistema e a apresentação do nome do usuário que esta na sessão.

### Criando a tela administrativa (admin.jsp):
```html
...
${notice}
...
```

Na tela administrativa iremos esperar apenas uma mensagem de boas vindas.

### Criando a tela de listagem (listagem.jsp):
```html
...
${notice}

<form action="${pageContext.request.contextPath}/usuario" method="post">
    <input type="text" name="usuario.nome" />
    <input type="submit" value="Salvar" />
</form>

<c:forEach items="${usuarioList}" var="usuario">
    ${usuario.nome}

    <form action="${pageContext.request.contextPath}/usuario/${usuario.id}" method="post">
       <input type="hidden" name="_method" value="delete" />
       <input type="submit" value="Remover" />
    </form>
</c:forEach>
...
```

Na tela de listagem temos um formulário para salvar o usuário e logo abaixo a listagem dos usuários já cadastrados com opção de removê-los.

Com isso preparamos todo o nosso ambiente, faltando apenas o controle de permissão de fato. Esse controlador será um Interceptor.

### Criando o interceptador de permissão (PermissionInteceptor.java):

Primeiramente devemos excluir as classes que não desejamos que sejam interceptadas.

```java
public boolean accepts(ResourceMethod method) {
    return
       !(method.getMethod().isAnnotationPresent(Public.class) ||
               method.getResource().getType().isAnnotationPresent(Public.class));
}
```

No método `accepts` não iremos interceptar nem os métodos nem os controllers que estiverem anotados com @Public.

E então em nosso método `intercepts` vamos criar a lógica das restrições.

```java
public void intercept(InterceptorStack stack, ResourceMethod method, Object resource) {
    Permission methodPermission = method.getMethod().getAnnotation(Permission.class);
    Permission controllerPermission = method.getResource().getType().getAnnotation(Permission.class);

    if (this.hasAccess(methodPermission) &amp;&amp; this.hasAccess(controllerPermission)) {
       stack.next(method, resource);
    } else {
       result.use(http()).sendError(403, "Você não tem permissão para tal ação!");
    }
}
```

Através do argumento `ResourceMethod` capturamos todas os atributos da anotação do tipo `Permission` do método acessado pegando o método usando o `getMethod` e em seguida a anotação passando seu tipo.

Para pegar a anotação do controller fazemos praticamente o mesmo processo alterando apenas o método `getMethod` para `getResource` e `getType`. - Se lembra que os nossos controllers são anotados com `@Resource`?

Então estas duas listas são passadas para o método `hasAccess` que responde se o usuário tem permissão de acesso ao recurso requisitado. Caso tenha, é chamado o método `next` do `InterceptorStack`, que da continuidade ao fluxo, caso contrário o usuário é redirecionado para a página negado.jsp.

O método que verifica se o usuário tem acesso ficará o seguinte:

```java
private boolean hasAccess(Permission permission) {
    if (permission == null) {
       return true;
    }

    Collection<Perfil> perfilList = Arrays.asList(permission.value());

    return perfilList.contains(userSession.getUser().getPerfil());
}
```

Se não houver anotação na lista recebida como argumento, quer dizer que não há restrições, logo, é retornado `true`, liberando o acesso. Caso contrário, é verificado se o usuário possui o perfil adequado. O método `hasAccess` é usado para analisar tanto a permissão do método quanto ao do controller, retornando `true` ou `false` para indicar a liberação do acesso.

### Contribuição

O [Rodrigo Ramalho](http://localhost:3000/2010/04/23/controle-de-permissao-com-vraptor-3#comment-152) contribuiu com o seguinte código para testar as anotações:

```java
   @Test
   @SuppressWarnings("rawtypes")
   public void createPermission() throws SecurityException, NoSuchMethodException{
       UserController controller = new UserController(result, userService, validator);
       Class c = controller.getClass();

       Method m = c.getMethod("create", User.class);
       Permission p = m.getAnnotation(Permission.class);

       Assert.assertNotNull(p);
       Assert.assertEquals(2, p.value().length);
       Assert.assertEquals(Role.ADMIN, p.value()[0]);
       Assert.assertEquals(Role.MEMBER, p.value()[1]);
   }
```

Com isso nosso controle de permissão esta pronto e qualquer classe que necessite de monitoramente poderá ser anotada e entrará automaticamente no controle de acesso.

Se você quiser ver como fica o controle login junto com o controle de permissão visite o projeto **VRaptor Starting Project**: [http://github.com/wbotelhos/vraptor-starting-project](http://github.com/wbotelhos/vraptor-starting-project)

### Link do projeto:

[http://github.com/wbotelhos/controle-permissao-vraptor-3](http://github.com/wbotelhos/controle-permissao-vraptor-3)
