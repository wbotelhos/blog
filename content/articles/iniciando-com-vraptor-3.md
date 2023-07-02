---
date: 2009-12-07T00:00:00-03:00
description: "Iniciando com VRaptor 3"
tags: ["java", "vraptor"]
title: "Iniciando com VRaptor 3"
---

**Atualizado em 20 de Novembro de 2010.**

Pra quem esta acompanhando a área de Java não é novidade alguma que o [VRaptor](http://vraptor.caelum.com.br) esta explodindo de sucesso e boas referências. Hoje trabalho em vários projetos na [Giran](http://giran.com.br) utilizando-o, e posso dizer que estou super satisfeito.

**Conhecendo a framework**

O VRaptor é um framework [MVC](http://pt.wikipedia.org/wiki/MVC) que trabalha com os métodos de seus controllers de forma exposta e de maneira **[RESTFul](http://pt.wikipedia.org/wiki/RESTful)**, ou seja, conseguimos acessar um método público, por exemplo, através da URI: `/usuario/cadastrar` de forma fácil e intuitiva. A seguir há uma lista resumida de algumas características:

- [Injeção de Dependência](http://pt.wikipedia.org/wiki/Inje%C3%A7%C3%A3o_de_depend%C3%AAncia);
- Cast automático;
- Conversores;
- Interceptadores;
- Integração com Spring, Hibernate e JPA;
- Facilidade de Testes de Unidade;
- Validações;
- Redirecionamentos;
- URI parametrizada;
- Entre outras mais...

E o melhor de tudo, é open source, brasileira e tem uma [lista de discussão](http://groups.google.com/group/caelum-vraptor) com pessoas dispostas a ajudar, além de poder acompanhar o desenvolvimento da framework.

**Objetivo**

Criar um [CRUD](http://pt.wikipedia.org/wiki/CRUD) de Usuário utilizando a [última versão](http://vraptor.caelum.com.br/download.jsp) do VRaptor 3 simulando a persistência no banco.

**Configurando o projeto**:

Depois de fazer o download do (blank project) e descompactar o arquivo vraptor-blank-project-3.x.x.zip na sua workspace, basta importar o projeto no [Eclipse](http://www.eclipse.org), adicioná-lo ao seu servidor e ele estará pronto para rodar.

>O projeto vem com alguns arquivos para ser executado no [NetBeans](http://netbeans.org) também, caso você não o utilize, precisará manter apenas as pastas Webcontent e src, podendo remover o restante.

**Criando o controller**

Criaremos o pacote `br.com.wbotelhos.controller` e dentro deste pacote um `IndexController`. (o blank project já contém um como exemplo)

```java
@Resource
public class IndexController {

    @Path("/")
    public void index() {
    }

}
```

Todos os nossos controllers terão o nome no formato NomePasta**Controller** e serão anotados com `@Resource` para expor seus recursos e tornar os métodos públicos acessíveis atavés da URL. No exemplo acima o caminho "`/`" irá executar o método `index`, tendo como regra o redirecionamento para uma página com o mesmo do método, contida dentro de uma pasta com o mesmo nome do controller `WEB-INF/jsp/**index**/**index**.jsp.` Todas as nossas páginas ficarão dentro de `WEB-INF/jsp/pasta`, onde pasta é o nome da entidade na qual queremos trabalhar.

**@Path**

O VRaptor é uma framework Action Based, logo os métodos são acessados via ações da URI, e estas devem ser únicas. A anotação Path indica a URI a ser acessada para que possamos executar um método. Por convenção o utilizado é o seguinte: `@Path("nomeEntidade/nomeMetodo")`:

```java
@Path("/usuario/listarTodos")
public void listar() { }
```

Se não tivéssemos anotado o método listar com o `@Path`, por padrão seria `/usuario/listar`, mas podemos anotar e o Path não precisa ter relação com o nome do método.

**Methods**

O acesso a um método é feito através das operações HTTP mais comuns como o `GET`, `POST`, `PUT` e `DELETE` que normalmente são combinadas a um CRUD.

Podemos fazer um esqueminha do tipo:
**GET** - Listar dados e acessar links;
**POST** - Salvar uma entidade;
**PUT** - Atualizar uma entidade; e
**DELETE** - Excluir uma entidade.

Mesmo que um método tenha o mesmo Path ele pode se diferenciar através do método executado:

```java
@Post
@Path("/usuario")
public void salvar() {
}

@Put
@Path("/usuario")
public void editar() {
}
```

Por padrão o acesso de um método é composto por `nomeController/nomeMetodo` via `@Get`, não sendo necessário neste caso anotar, porém recomendo sempre explicitar, evitando confudir o método de acesso assim como o caminho.

**Criando a página inicial**

Agora criaremos uma página chamada `index.jsp` dentro de uma pasta chamada `index` contendo um menu para a navegação:

```jsp
...
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
...
<a href="<c:url value='/usuario/novo'/>">Novo usuário
...
```

Utilize sempre a tag URL da biblioteca core para que as URLs sejam montadas corretamente.

Pronto! Podemos testar nossa aplicação. Adicione o projeto ao servidor e verá que o nome estará **vraptor-blank-project**. Esse é o nome default e é através dele que iremos acessar a aplicação: `http://localhost:8080/vraptor-blank-project/`. Mas queremos usar outro nome, então irei mostrar como trocar, pois renomear a pasta do projeto apenas não irá resolver.

**Trocando o nome de deploy e o context-root da aplicação**:

- Visualize os arquivos ocultos e dentro da pasta do projeto conterá uma outra chamada `.settings`;
- Abra o arquivo `org.eclipse.wst.common.component` em um editor de texto;
- Altere a tag "`deploy-name`" para alterar o nome visualmente ao escolher a aplicação para deploy;
- Altere a propriedade "`context-root`" para alterar o contexto de acesso da aplicação;
- Faça o deploy e verá as alterações, podendo escolher o nome que achar melhor, no caso escolhi "project".

**Criando a página de cadastro do usuario** (novo.jsp)

Criaremos 1 Controller + 1 DAO + 1 Pasta contendo as páginas.

```html
...
<form action="<c:url value='/usuario'/>" method="post">
    Nome: <input type="text" name="usuario.nome" value="${usuario.nome}"/><br/>
    Senha: <input type="text" name="usuario.senha" value="${usuario.senha}"/><br/>
    E-mail: <input type="text" name="usuario.email" value="${usuario.email}"/><br/>
    <input type="submit" value="Salvar"/>
</form>
...
```

A action do formulário acessa `/usuario` via `POST`.
Através do parâmetro `name`, setamos os valores nos atributos do objeto `usuario`.
Através do parâmetro `value`, recuperamos o objeto `usuario` e utilizamos seus atributos para popular os campos.

**Criando o modelo do usuário**

```java
private Integer id;
private String nome;
private String senha;
private String email;

// Getters e Setters.
```

Lembre-se que atributo `name="usuario.nome"` acessa de fato o objeto `Usuario` e tanto o objeto quanto seus atributos devem existir.

**Criando o controller do usuário**

De acordo com a ação do nosso formulário, criaremos um método acessado pela URI `/usuario` via `POST`.

```java
@Post
@Path("/usuario")
public void salvar() { }
```

Ainda falta o objeto no qual seto os valores dos campos do formulário. Diferente do `useBean` do JSP os valores são setados em um objeto presente no próprio controller, falicitando assim o uso do mesmo. Este objeto assim como qualquer outro que formos trabalhar devem estar presentes como argumento do método invocado, podendo ser mais do que um:

```java
@Post
@Path("/usuario")
public void salvar(Usuario usuario) { }
```

Com o objeto alimentado a partir do formulário podemos persistí-lo.

**Trabalhando com redirecionamento**:

Ao tentarmos salvar um usuário teremos um erro 404, pois seremos redirecionados para uma página com o mesmo nome do método: `WEB-INF/jsp/usuario/salvar.jsp`, mas como queremos manter o nome do método, porém sermos redirecionados para a página `listagem.jsp` teremos de fazer o redirecionamento no final do método.

Temos dois tipos de redirecionamentos:

**Results.logic()**

Redirecionamento para um método qualquer dos controllers. Devemos passar a classe do controller que iremos utilizar:

```java
result.use(Results.logic()).redirectTo(UsuarioController.class).listagem();
```

`UsuarioController.class` pode ser substituido por `getClass()` indicado a própria classe, ou qualquer outro `Controller.class`.

**Results.page()**

Redirecionamento para uma página. Indicamos o caminho da página na qual queremos ser redirecionados (redirect) ou encaminhados (forward):

```java
result.use(Results.page()).forward("WEB-INF/jsp/listagem.jsp");
```

Para maiores informações sobre a diferença entre os dois tipos leia [este artigos](http://www.rponte.com.br/2008/07/12/repitam-comigo-redirect-nao-e-forward) do [Rafael Ponte](http://twitter.com/rponte). (:

Nas últimas versões do VRaptor é possível usar estes métodos de forma resumida:

```java
result.redirectTo(this).listagem(); // Poderia ser um fowardTo
```

Veja que já é entendido que `listagem` é um método, logo por debaixo dos panos é usado o `Results` necessário. Não é mais preciso especificar se será usado `logic` ou `page`. Também foi simplificado o uso do `getClass()` para simplesmente `this`, representando o próprio controller.

Ainda existem vários outros tipos de `Results`, mas por hora é isso que precisamos saber.

Voltando ao código, então teríamos nosso controller assim:

```java
@Resource
public class UsuarioController {

    private Result result;

    @Get
    @Path("/usuario/novo")
        public void novo() {
    }

    @Post
    @Path("/usuario")
    public void salvar(Usuario usuario) {
        // Método que salva.
        result.forwardTo("WEB-INF/jsp/usuario/listagem.jsp");
    }
}
```

Colocamos o caminho das páginas a partir da pasta `WEB-INF`.

**Injeção de dependência**

Certamente se formos utilizar o método `salvar` seria lançado um `NullPointerException`, pois o objeto `result` não esta instanciado. Uma grande facilidade que temos é a injeção de dependência na qual injetamos o objeto através do contrutor da classe e a framework trata de controlar o que é necessário para intanciá-lo.

```java
public UsuarioController(Result result) {
    this.result = result;
}
```

Então agora já temos nosso `result` instanciado. Da mesma forma se quiséssemos trabalhar com outros controllers, por exemplo, apenas injetaríamos os mesmos.

> Por boas práticas recomenda-se criar interfaces com as assinaturas de suas classes e na injeção passá-las em vez das classes concretas, falicitando deste modo os testes de unidades, além de ter uma interface externa de acesso para sua aplicação.

**Criando o Dao**

Precisamos da camada de persistência e esta camada deve ser anotada como `@Component`. Componentes são instâncias de classes utilizadas pela sua aplicação para executar tarefas ou armazenar estados em diferentes formas. O Dao é um exemplo clássico.

Para o nosso exemplo, apenas para facilitar didáticamente, iremos colocar a classe como escopo de sessão para que possamos manter o estado dos nossos dados e simular o banco. Os escopos existentes são:

**RequestScoped**: estará disponível apenas durante a requisição;
**ApplicationScoped**: será apenas um por aplicação;
**SessionScoped**: será o mesmo durante uma http session; e
**PrototypeScoped**: instanciado sempre que requisitado.

```java
@SessionScoped
@Component
public class UsuarioDao {

    private List<Usuario> usuarioList = new ArrayList<Usuario>();
    private Integer id = 1;

    public void salvar(Usuario usuario) {
        usuarioList.add(usuario);
        usuario.setId(id++);
    }

}
```

**Listando os dados**: (listagem.jsp)

Para podermos listar nossas informações salvas, devemos passar estes dados através do `request` que o VRaptor encapsula, assim como o `response`, tornando esta tarefa mais fácil. O Result será utilizado para incluir os dados da seguinte forma:

```java
result.include("usuarioList", usuarioList);
```

Para recuperarmos a lista do request podemos utilizar [EL](http://en.wikipedia.org/wiki/Expression_Language) da seguinte forma: `${usuarioList}`.

```html
...
<table>
    <thead>
        <tr>
      <th>Nome</th>
            <th>Senha</th>
     <th>E-mail</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${usuarioList}" var="item">
            <tr>
                <td>${item.nome}</td>
                <td>${item.senha}</td>
                <td>${item.email}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
...
```

No caso acima nós que incluímos a lista no request, porém por padrão o retorno já é colocado no request. O nome do retorno é formado pelo tipo da lista caso tenha mais o nome "List": `public List listar();` seria capturado como `${usuarioList}` e se for apenas um objeto basta capturar o nome começando em minísculo: `public Usuario consultar();` seria capturado como `${usuario}`.

Vamos adicionar o método que retorna a lista no Dao:

```java
public List<Usuario> loadAll() {
    return usuarioList;
}
```

E também no Controller:

```java
@Get
@Path("/usuario")
public List<Usuario> listagem() {
    return usuarioDao.loadAll();
}
```

No método acima estou usando o default e deixando ele colocar o `usuarioList` no `resquest` assim como fazer o redirecionamento para `listagem.jsp`.

**Criando a lógica para editar**

Vamos adicionar uma coluna na tabela da listagem de dados para conter um link para a edição:

```html
...
<td>
    <form action="<c:url value='/usuario'/>" method="post">
        <input type='hidden' name='_method' value='put'/>
        <input type='hidden' name='usuario.id' value='${item.id}'/>
        <input type="submit" value="Editar"/>
    </form>
</td>
...
```

Como nosso método editar é acessado via `PUT` teremos de fazer o formulário utilizá-lo, já que só há o suporte como `GET` e `POST` hoje em dia. Para isso criamos um campo `hidden` (que não aparece na tela) sobrescrevendo o atributo `_method` com o valor `PUT`, atributo no qual indica qual método que o formulário executará. O atributo `id` do objeto `Usuario` também esta escondido servindo apenas para indicar qual usuário queremos editar.

No nosso controller teremos o seguinte método:

```java
@Put
@Path("/usuario")
public void editar(Usuario usuario) {
    Usuario entity = usuarioDao.loadById(usuario);
    result.redirectTo(this).novo(entity);
}
```

Repare que após recuperarmos o usuário que queremos editar fazemos uma chamada ao método `novo()`, pois é ele que redireciona para nosso formulário, porém preciso levar o usuário consultado para a tela, logo passo ele para o método que foi refatorado para incluir o usuário no request:

```java
@Get
@Path("/usuario/novo")
public void novo(Usuario usuario) {
    result.include("usuario", usuario);
}
```

No nosso Dao também iremos adicionar o método que consulta o usuário pelo ID:

```java
public Usuario loadById(Usuario usuario) {
    Usuario usuarioDelete = null;

    for (Usuario item : usuarioList) {
        if (item.getId() == usuario.getId()) {
            usuarioDelete = item;
            break;
        }
    }

    removerItem(usuarioDelete); // *
    return usuarioDelete;
}
```

> * `removerItem(usuarioDelete)` foi utilizado aqui apenas por não usármos um banco de dado real e o editar ser na verdade um remover e logo em seguida um salvar.

Procuro o usuário com o ID passado e o guardo, logo em seguida removo ele da lista:

```java
private void removerItem(Usuario usuarioDelete) {
    if (usuarioList.remove(usuarioDelete)) {
        id--;
    }
}
```

<blockquote>Se desistirmos de salvar o usuário lá no formulário o mesmo já terá sido removido, mas o exemplo é simbólico.</blockquote>

**Criando a lógica de exclusão**

O método para deletar segui o mesmo raciocínio do editar, só não tendo que retornar os dados para a tela.
Vamos adicionar uma coluna na tabela da listagem de dados para conter um link para a remoção:

```html
<td>
    <form action='<c:url value="/usuario"/>' method="post">
        <input type='hidden' name='_method' value='delete/>
        <input type='hidden' name='usuario.id' value='${item.id}'/>
        <input type="submit" value="Excluir"/>
    </form>
</td>
```

Vamos criar um método anotado com `@Delete` no controller:

```java
@Delete
@Path("/usuario")
public void remover(Usuario usuario) {
    usuarioDao.remover(usuario);
    result.use(Results.logic()).redirectTo(getClass()).listagem();
}
```

E então repassaremos para o nosso Dao remover o objeto:

```java
public void remover(Usuario usuario) {
    Usuario usuarioDelete = null;

    for (Usuario item : usuarioList) {
        if (item.getId() == usuario.getId()) {
            usuarioDelete = item;
            break;
        }
    }

    removerItem(usuarioDelete);
}
```

No método acima busco pelo ID, ao achar guardo o objeto e o removo da lista. Em uma situação real removeríamos o objeto do banco de dados de acordo com o ID passado.

**Conclusão**

De forma fácil conseguimos criar um CRUD sem nos preocupar com requisições, conversões de dados e redirecionamentos. Podemos fazer isso e muito mais com o VRaptor. E se esta preocupado com a parte visual é só dar uma olhada no [jQuery UI](http://jqueryui.com).

Para quem quiser se aprofundar mais no VRaptor, acompanhe a [lista de discussão](http://groups.google.com/group/caelum-vraptor), de uma olhada na [documentação oficial](http://vraptor.caelum.com.br/documentacao) disponível em português ou continue acompanhando os artigos aqui no [Blog](http://wbotelhos.com.br).

**Link do projeto**:

[http://github.com/wbotelhos/iniciando-com-vraptor-3](http://github.com/wbotelhos/iniciando-com-vraptor-3)
