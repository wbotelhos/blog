---
date: 2010-01-20T00:00:00-03:00
description: "Manipulando Dados JSon Via Ajax Com VRaptor 3"
tags: ["java", "vraptor", "ajax", "json"]
title: "Manipulando Dados JSon Via Ajax Com VRaptor 3"
---

Olá pessoal,

Falarei um pouco de um novo jeito de manipular dados: [JSon](http://www.json.org).

Com o JSon é possivel transformar um objeto Java em um conjunto de Strings que representará seu objeto e terá a forma de acesso aos seus atributos da mesma forma que um objeto Java normal, tornando-se um intermediário poderoso entre uma linguagem e o JavaScript.

### Objetivo

Criar uma função que busca um usuário no banco e coloca os dados em um formulário deixando tudo pronto para uma edição, tudo via ajax utilizando JSon como meio de transporte e o VRaptor como gerenciador.

Para começarmos precisaremos de um projeto VRaptor, você pode baixar o [Blank Project](http://vraptor.caelum.com.br/download.jsp) que atualmente esta em sua versão 3.1 e caso tenha alguma dificuldade poderá ler o artigo [Iniciando Com VRaptor 3](http://wbotelhos.wordpress.com/2009/12/07/iniciando-com-vraptor-3)

### Mãos à obra

Começaremos criando um classe chamada `Contato`:

```java
public class Contato {

    private String telefone;
    private String celular;

   // getters e setters

}
```

E outra classe `Usuario` que possui um `Contato`.

```java
public class Usuario {

    private Long id;
    private String nome;
    private String senha;
    private String email;
    private Contato contato;

    // getters e setters

}
```

Criamos duas classes nas quais representarão os dados do usuário buscado no banco.

Criaremos um DAO para simular o retorno do usuário a partir do banco:

```java
@Component
public class UsuarioDao {

    public Usuario loadById(Long id) {
        if (id != null) {
            Usuario usuario = new Usuario();
            usuario.setId(id);
            usuario.setEmail("botelho@email.com");
            usuario.setNome("Washington Botelho dos Santos");
            usuario.setSenha("wbotelhos");

            Contato contato = new Contato();
            contato.setCelular("13012010");
            contato.setTelefone("13012005");

            usuario.setContato(contato);

            return usuario;
        }

        return null;
    }
}
```

Nosso DAO simula a recepção de um ID que a partir do mesmo buscaria um usuário no banco, mas ao invés disso, apenas criaremos um objeto `Usuario` na mão e retornaremos para quem chamar o método `loadById`.

Com nossa camada de persistência pronta vamos criar o controller que irá gerenciar nossas ações:

```java
@Resource
public class UsuarioController {

    private UsuarioDao usuarioDao;
    private Result result;

    public UsuarioController(Result result, UsuarioDao usuarioDao) {
        this.result = result;
        this.usuarioDao = usuarioDao;
    }

    @Get
    @Path("/usuario")
    public void novo() {
    }

    @Get
    @Path("/usuario/editar/{usuario.id}")
    public void editar(Usuario usuario) {
        Usuario user = usuarioDao.loadById(usuario.getId());
        result.use(json()).from(user).include("contato").serialize();
    }

}
```


- Injetamos o `Result` e o `UsuarioDao` para que possamos utilizá-los no controller;
- Um método para redirecionar para a página `novo.jsp` na qual contêm nosso formulário e se encontra dentro da pasta usuario; e
- Um método `editar` que recebe um ID e chama o DAO para buscar o usuário correspondente no banco.

Pra quem já esta familiarizado com o VRaptor, este controller não tem nada demais, a não ser uma recente funcionalidade na qual [serializa](http://pt.wikipedia.org/wiki/Serializa%C3%A7%C3%A3o) um objeto em formato JSon:

```java
result.use(json()).from(user).include("contato").serialize();
```

Nessa linha acima dizemos ao result que iremos utilizar o resultado em formato JSon e logo em seguida dizemos de onde virá os dados, neste caso do objeto `Usuario` que acabamos de buscar no banco. Sei que você lembrou que este possui uma referência para um objeto `Contato`, e logo percebeu que o incluímos na serialização, bastanto agora apenas chamar o método `serialize` para concluir a ação.

### Onde ficam estes dados?

Caso não serializássemos o nosso objeto o VRaptor iria nos redirecionar para a página `/usuario/novo.jsp`, porém mudamos o [content-type](http://pt.wikipedia.org/wiki/MIME) do nosso resultado para `json()` com isso iremos para uma "página" criada pelo VRaptor com os dados serializados.

> Se acessarmos a URL http://ip:porta/json-ajax-vraptor-3/usuario/editar/1 por exemplo o navegador irá pedir para fazermos download de um arquivo sem extensão de mesmo nome do ID que passamos, no caso 1. Abra este arquivo e verá os dados serializados.

### Como são estes dados serializados?

Os dados são de simples leitura representados por Strings sempre dentro de chaves iniciais padrão:

```json
{
    "usuario": {
        "id": 2,
        "nome": "Washington Botelho dos Santos",
        "senha": "wbotelhos",
        "email": "botelho@email.com",
        "contato": {
            "telefone": "13012005",
            "celular": "13012010"
        }
    }
}
```

- Nosso JSon começa com chaves e dentro delas o nome do nosso objeto que se chama `usuario`;
- Dentro de `usuario` envolvido por chaves para indicar um conjunto de atributos pertecente a um objeto esta todos os atributos do objeto `usuario`;
- Separamos do lado esquerdo o nome do atributo e do lado direto separado por dois pontos ':' o valor do atributo em questão;
- Repare que temos todos nossos atributos entre aspas, assim como os valores dos mesmos;
- Temos um sub-bloco dentro de `usuario` chamado de `contato`, que também é um objeto, logo os atributos de contato também estarão contidos dentro de um conjunto de chaves.

> Por padrão o nome do objeto é utilizado no JSon, caso queira personalizá-lo basta incluir como primeiro parâmetro do método `from` o nome que deseja: `.from("nomeObjeto", user)`>

Parabéns, você agora já conhece o formato JSon e já esta preparado para capturar estes dados e manipulá-los da forma que achar melhor. O VRaptor já fez seu trabalho, agora vamos desfrutar do [Ajax](http://pt.wikipedia.org/wiki/AJAX_%28programa%C3%A7%C3%A3o%29) para concluirmos nosso objetivo e nos tornamos "Trendys"! d:B

### Formulário de edição:

Vamos criar nosso formulário que será preenchido com os dados consultados:

```html
<form>
    ID: <input id="id" type="text"/>
    Nome: <input id="nome" type="text"/>
    Senha: <input id="senha" type="text"/>
    E-mail: <input id="email" type="text"/>

    Telefone: <input id="telefone" type="text"/>
    Celular: <input id="celular" type="text"/>

    <input type="button" value="Salvar"/>
</form>
```

Um formulário normal, sem muito segredo. Todos os campos devem ter um ID para servir de âncora e podermos manipulá-los.

Também criaremos um formulário para que possamos digitar o ID da consulta:

```html
<form>
    Buscar ID: <input id="idBusca" type="text"/>
    <input type="button" value="Consultar" onclick="consultar();"/>
</form>
```

Com isso nosso objetivo esta quase concluído, faltando apenas fazer uma manipulação JavaScript.

Como sabemos trabalhar com JavaScript puramente é massante, trabalhoso e mais propício a erros, então vamos ser "descolados" e utilizar uma [framework](http://pt.wikipedia.org/wiki/Framework), no caso o [jQuery](http://jquery.com).

> Ah! No dia 14 de Janeiro de 2009 foi aniversário do jQuery e nada melhor do que começarmos a utilizar sua nova [versão 1.4](http://code.jquery.com/jquery-1.4.min.js). (;

Vamos importar o script `jquery-1.4.js`:

```js
<script type="text/javascript" src="<c:url value='/js/jquery-1.4.js'/>"></script>
```

Com o script importado só nos resta criar a função que chama a página com os dados JSon via Ajax e logo em seguida utilizá-los. (:

### Função JavaScript Consultar:

Primeiramente vamos declará-la e já capturar o ID pelo qual o usuário quer fazer a busca.

```js
<script type="text/javascript">
    function consultar() {
        var idBusca = $('#idBusca').val();
               // ...
    }
</script>
```

Precisamos agora de um método do jQuery chamado [getJSON](http://docs.jquery.com/Getjson), no qual a partir de uma url nos retorna um objeto em JavaScript vindo de uma página com dados JSon via ajax, ou seja, de forma assíncrona.

```js
$.getJSON('<c:url value="/usuario/editar/"/>' + idBusca, function (json) {
    // ...
}
```

A passagem de parâmetro como segundo argumento é opcional e como queremos passar apenas o valor do ID para ser "injetado" na entidade que o espera no controller, este foi passado embutido no primeiro parâmetro junto a URL.

> Podemos também utilizar a função que nos retorna um JSon via post, porém não existe postJSON, sendo necessário passar um parâmetro entre aspas do tipo do retorno, no caso 'json' logo após o callback.

O callback (retorno) estando contindo dentro da variável `json`, podemos utilizar este conteúdo como se fosse um objeto normal, assim se temos um objeto `Usuario`, basta acessar seus atributos com um ponto '.' da mesma forma que um objeto Java, ficando nosso método final o seguinte:

```js
<script type="text/javascript">
    function consultar() {
        var idBusca = $('#idBusca').val();

        $.getJSON('<c:url value="/usuario/editar/"/>' + idBusca, function (json) {
            $('#id').val(json.usuario.id);
            $('#nome').val(json.usuario.nome);
            $('#email').val(json.usuario.email);
            $('#senha').val(json.usuario.senha);

            $('#telefone').val(json.usuario.contato.telefone);
            $('#celular').val(json.usuario.contato.celular);
        });
    }
</script>
```

Pronto, agora cada campo recebe seus devidos valores de atributo.

Com isso vimos como o VRaptor nos ajuda a criar o JSon, uma ótima estrutura de dados na qual é totalmente compatível com JavaScript e consequentemente muito conveniente a implementação com Ajax.

### Link do projeto:

[http://github.com/wbotelhos/manipulando-dados-json-via-ajax-com-vraptor-3](http://github.com/wbotelhos/manipulando-dados-json-via-ajax-com-vraptor-3)
