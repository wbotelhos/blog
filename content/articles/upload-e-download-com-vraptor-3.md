---
date: 2010-07-28T00:00:00-03:00
description: "Upload e Download com VRaptor 3"
tags: ["java", "vraptor", "upload", "download"]
title: "Upload e Download com VRaptor 3"
---

É normal nos cadastrarmos em um sistema e lá ter uma opção de enviar sua própria foto. Outra opção mais do que usada é o simples download de algum arquivo. Iremos ver como o [VRaptor](http://vraptor.caelum.com.br/documentacao/vraptor3-guia-de-1-minuto) nos auxiliam nessas tarefas e nos poupam um bocado de código e tempo.

### Objetivo:

Criar uma funcionalidade na qual o usuário pode enviar uma foto para o sistema como seu avatar e logo em seguida fazer a apresentação desta imagem na tela.

### Criando o usuário (Usuario.java):

```java
public class Usuario {

  private Integer id;
  private String foto;

  // get and set...

}
```

Precisamos do ID do usuário para ser usado como identificador na foto e um campo String para mantermos o nome da foto.

### Criando a sessão do usuário (UserSession.java):

```java
@Component
@SessionScoped
public class UserSession {

  private Usuario user;

  // getters and setters...

}
```

Para trabalharmos com o avatar do usuário logado, precisamos ter este usuário em sessão, logo criamos tal componente que é `SessionScoped`.

### Criando a classe de negócios (UsuarioBusiness.java):

<span style="text-decoration: underline;">Salvando a imagem do usuário</span>:

```java
public void salvarFoto(UploadedFile imagem) throws IOException {
  Usuario user = userSession.getUser();

  if (imagem != null) {
    String fileName = imagem.getFileName();

    int start = fileName.lastIndexOf(".");
    String extensao = (start > 0) ? fileName.substring(start) : ".jpg";

    user.setFoto(user.getId() + extensao);

    try {
      IOUtils.copy(imagem.getFile(), new FileOutputStream(new File(PATH_FOTO, user.getFoto())));
    } catch (FileNotFoundException e) {
      e.printStackTrace();
      throw new FileNotFoundException("Arquivo não encontrado!");
    } catch (IOException e) {
      e.printStackTrace();
      throw new IOException("Não foi possível enviar o arquivo!");
    }
  }

  this.atualizarFoto(user);
  userSession.setUser(user);
}
```

Linha 5-10:
É recuperado o nome do arquivo e em seguida sua extensão que é concatenado com o ID do usuário. Depois é colocado de volta este novo nome na entidade para que seja persistida.

> Usamos o ID do usuário como o nome do avatar porque o mesmo não se repete e facilita para localização.

Linha 13:
É utilizado o método `copy` da biblioteca [commons-io](http://commons.apache.org/io) da Apache para pegar a stream de entrada da imagem e jogar para uma stream de saída em um local físico.

> Armazene as imagens em uma pasta fora da sua aplicação, pois assim você evita ter que fazer backup a cada redeploy, já que isto apaga todo conteúdo da sua aplicação.

Linha 23-24:
É feita a atualização dessa imagem no banco e reposto o usuário na sessão.

<span style="text-decoration: underline;">Removendo a imagem do usuário</span>:

```java
public void removerFoto() {
  Usuario user = userSession.getUser();

  if (user.getFoto() != null &amp;&amp; !user.getFoto().isEmpty() &amp;&amp; !user.getFoto().equals("default.jpg")) {
    File file = new File(PATH_FOTO, user.getFoto());

    if (file.exists()) {
      file.delete();
    }
  }

  user.setFoto("default.jpg");

  this.trocarFoto(user);
  userSession.setUser(user);
}
```

Linha 4:
É verificado se o usuário esta usando uma imagem e se esta não é a imagem padrão (default.jpg).

> É importante verificar se o usuário não esta usando a imagem padrão, pois se esta for removida todos os usuários com imagem padrão serão prejudicados, já que todos apontam para a única e mesma imagem.

Linha 5-9:
É recuperado a imagem e verificado se a imagem existe, se sim, a mesma é removida.

Linha 12:
Como não deixamos o usuário sem foto, é setado a imagem padrão para o mesmo.

Linha 14-15:
É feito a atualização do nome da nova imagem no banco e reposto o usuário na sessão.

<span style="text-decoration: underline;">Método usado para o download</span>:

```java
public File downloadFoto() {
  File file = new File(PATH_FOTO, userSession.getUser().getFoto());
  return (file.exists()) ? file : new File(PATH_FOTO + "/default.jpg");
}
```

Procuramos a imagem do usuário, se ela existir é retornada, senão retornamos a imagem padrão.

### Criando o controlador (UsuarioController.java):

<span style="text-decoration: underline;">Recebendo a imagem do usuário</span>:

```java
@Post
@Path("/usuario/foto")
public void atualizarFoto(UploadedFile imagem) {
  try {
    business.atualizarFoto(imagem);
  } catch (IOException e) { // Sua exception...
    result.include("error", e.getMessage()).forwardTo(this).upload();
  }

  result.redirectTo(this).upload();
}
```

Nosso método espera como argumento um `UploadedFile` que, de fato, é a imagem enviada pelo usuário através do formulário. E então a passamos para a nossa classe de negócios salvá-la em disco.

Ahm? E cadê o servlet com meus objetos `ServletFileUpload`, `DiskFileItemFactory` e etc para fazer esse upload?

Esquece isso, o VRaptor já tem tudo "mastigado" na classe `UploadedFile` que intercepta o envio do formulário com a imagem e já faz isso tudo por você. Basta manipulá-la como uma stream. (:

> Estou ouvindo você falar: "Maldito servlet de upload que eu fazia na unha."

<span style="text-decoration: underline;">Removendo a imagem do usuário</span>:

```java
@Get
@Path("/usuario/foto/remover")
public void atualizarFoto() {
  business.removerFoto();
  result.redirectTo(this).upload();
}
```

O método para remover a imagem simplesmente chama o nosso método já construido na nossa classe de negócios.

### Fazendo o download da imagem:

```java
@Get
@Path("/usuario/foto")
public File downloadFoto() {
  return business.downloadFoto();
}
```

No download temos um outra facilidade, já que precisamos apenas de retorna um `File` que o VRaptor já repassa para a view que iremos ver como irá ficar a seguir.

### Criando a página de envio da foto (upload.jsp):

Para apresentar nossa foto na view, iremos fazer algo que até o dia em que o [Makoto](http://www.twitter.com/makotovh) me falou eu não sabia.

<span style="text-decoration: underline;">Apresentando a imagem do download</span>:

```html
<a href="${pageContext.request.contextPath}/usuario/foto">
    <img src="${pageContext.request.contextPath}/usuario/foto" border="0"/>
</a>
```

Adicionamos diretamente como atributo a URL do nosso controller que nos retorna um `File`, se lembra? Então você me pergunta: "tá, eu tenho um `File` e não o caminho da imagem".

O caminho direto não importa, sua aplicação não achará nenhum caminho fora dela mesmo, então fazemos um download e recuperamos essa imagem como uma stream, e esta pode ser setada diretamente no `src` do componente da imagem. :o

> Se você não quiser fazer download da imagem terá de deixá-la dentro da sua aplicação.

<span style="text-decoration: underline;">Upload da imagem</span>:

```html
<form action="${pageContext.request.contextPath}/usuario/foto" enctype="multipart/form-data" method="post">
  Imagem: <input type="file" name="imagem"/> <input type="submit"/>
</form>
```

Nosso formulário submete a foto para a URL do método que a atualiza em nosso controller via `POST`. Precisamos de habilitar o envio de "anexo" do nosso formulário com o atributo `enctype` como `multipart/form-data`. Não se esqueça!

<span style="text-decoration: underline;">Remoção da imagem</span>:

```html
<a href="${pageContext.request.contextPath}/usuario/foto/remover">Remover</a><br/>
```

Para remover a imagem basta chamar o link de remoção e o usuário passará a ter a foto padrão.

Agora que você já sabe fazer upload e download de arquivos, irei listar algumas melhorias que eu costumo fazer em minhas aplicações que não cabe mostrar aqui neste artigo, mas que poderia ser uma segunda parte no futuro:

+ Fazer o upload e download via ajax usando o [jQuery Form](http://jquery.malsup.com/form);
+ Validar a extensão ainda na view com o [jQuery Validation](http://bassistance.de/jquery-plugins/jquery-plugin-validation);
+ Validar a extensão também server side;
+ Aumentar ou diminuir o limite do upload;
+ Retorna uma imagem de erro caso ocorra uma exception;
+ Integrar com o [Gravatar](http://gravatar.com).

**Link do projeto**:
[http://github.com/wbotelhos/upload-e-download-com-vraptor-3](http://github.com/wbotelhos/upload-e-download-com-vraptor-3)
