# encoding: utf-8

Category.create({ :name => "Agile" })
Category.create({ :name => "Amazon" })
Category.create({ :name => "CSS" })
Category.create({ :name => "Curso" })
Category.create({ :name => "Evento" })
Category.create({ :name => "Hibernate" })
java = Category.create({ :name => "Java" })
Category.create({ :name => "JavaScript" })
Category.create({ :name => "JPA" })
Category.create({ :name => "jQuery" })
Category.create({ :name => "JSF" })
Category.create({ :name => "JSon" })
Category.create({ :name => "JSP" })
Category.create({ :name => "MySQL" })
Category.create({ :name => "Plugin" })
ruby = Category.create({ :name => "Ruby" })
Category.create({ :name => "Sitemesh" })
Category.create({ :name => "Taglibs" })
Category.create({ :name => "Template" })
Category.create({ :name => "Tomcat" })
test = Category.create({ :name => "Test" })
Category.create({ :name => "VRaptor" })
Category.create({ :name => "XStream" })

Link.create({ :name => "Washington Botelho [US]", :url => "http://wbotelhos.com" })
Link.create({ :name => "Mockr.me", :url => "http://mockr.me" })
Link.create({ :name => "yLabs", :url => "http://wbotelhos.com/labs" })
Link.create({ :name => "jIntegrity", :url => "http://jintegrity.com" })

user = User.create({
  :name => "Washington Botelho",
  :email => "wbotelhos@gmail.com",
  :bio => "Desenvolvedor Java, Ruby e Python no Portal <a href=\"http://r7.com\" target=\"_blank\">R7.com</a>.\nÉ Baicharel em Sistemas de Informação e certificado OCJA 1.0 e OCJP 6.\nAjudante e aprendiz da comunidade open source e metido a designer.\n Além disso é apaixonado pela dança, skate, jiu-jitsu e Counter Strike Source. (:",
  :github => "http://github.com/wbotelhos",
  :twitter => "http://twitter.com/wbotelhos",
  :linkedin => "http://linkedin.com/in/wbotelhos",
  :facebook => "http://facebook.com/wbotelhos",
  :password => "test",
  :password_confirmation => "test"
})

article = user.articles.new({ :title => "01. Pedro pode ter sequela se recuperação será lenta", :body => "Gostaria de enfatizar que o julgamento imparcial das eventualidades maximiza as possibilidades por conta das posturas dos órgãos dirigentes com relação às suas atribuições. Podemos já vislumbrar o modo pelo qual a constante divulgação das informações desafia a capacidade de equalização de todos os recursos funcionais envolvidos. As experiências acumuladas demonstram que o surgimento do comércio virtual exige a precisão e a definição das condições inegavelmente apropriadas. A nível organizacional, o início da atividade geral de formação de atitudes oferece uma interessante oportunidade para verificação dos procedimentos normalmente adotados. O que temos que ter sempre em mente é que o desenvolvimento contínuo de distintas formas de atuação agrega valor ao estabelecimento das diretrizes de desenvolvimento para o futuro. " })
article.categories << ruby
article.save

article = user.articles.new({ :title => "02. Volta do goleiro Bruno ao futebol beira o absurdo", :body => "    Outros três clubes fizeram proposta para ter Bruno     Copa do Brasil: acompanhe aqui Botafogo contra Vitória     Falcao resolve e Atlético     de Madri vence a Liga Europa     Cosme Rímoli: vítima de racismo, Neymar vira acusado" })
article.categories << ruby
article.save

article = user.articles.new({ :title => "03. Parlamentares contestam sigilo da CPI do Cachoeira", :body => "A CPMI (Comissão Parlamentar Mista de Inquérito) do caso Cachoeira, que investiga o bicheiro Carlos Augusto Ramos, volta a discutir a convocação do procurador geral da República, Roberto Gurgel. Nesta quarta-feira (9), deputados da CPMI foram ao STF (Supremo Tribunal Federal) pedir o fim do sigilo nos depoimentos. " })
article.categories << ruby
article.save

article = user.articles.new({ :title => "04. Camarim exclusivo de Ivete gera inveja na Globo", :body => "Carolina Dieckmann acionou a justiça após ser exposta na web em fotos íntimas. Chantageada, a atriz contratou o advogado Antônio Carlos Almeida Castro para cuidar de seu caso. Agora, sua rotina inclui algumas idas à delegacia para prestar depoimentos e correr atrás de seus direitos. Acompanhe o caso. E mais: veja a rotina dos famosos!" })
article.categories << ruby
article.save

article = user.articles.new({ :title => "05. Segundo turno em São Paulo", :body => "Pesquisa Ibope/Rede Globo revelada nesta quarta-feira (9) mostra que se o segundo turno das eleições para a Prefeitura de São Paulo fosse hoje, ele seria disputado por José Serra (PSDB) e Celso Russomanno (PRB)." })
article.categories << ruby
article.save

article = user.articles.new({ :title => "06. SBT não consegue se livrar da maldição do Chaves", :body => "Entra ano e sai ano e o seriado do Chaves continua lá no SBT. Isso já faz o quê? 30 anos? A nova polêmica é que há alguns dias o canal tirou a série do ar. Uma das desculpas é que a atração pré-histórica estava desgastada e pedia um tempo de descanso." })
article.categories << ruby
article.save

article = user.articles.new({ :title => "07. Juliana Paes será vizinha do jogador Adriano", :body => "A atriz, que viverá a nova Gabriela, pagou, aproximadamente, R$ 3 milhões por uma mansão em um condomínio na Barra da Tijuca. " })
article.categories << ruby
article.save

article = user.articles.new({ :title => "08. Silvio tira a filha do ar", :body => "Tudo para voltar a exibir Chaves, pois o público estava reclamando e fazendo protestos em redes sociais, pedindo a volta do programa mexicano." })
article.categories << ruby
article.save

article = user.articles.new({ :title => "09. Veja convite de casamento de Mirella Santos e Ceará", :body => "O casal já disparou os convites para seus amigos e familiares.  O promoter David Brazil é um dos convidados e mostrou o convite assim que o recebeu. " })
article.categories << ruby
article.save

article = user.articles.new({ :title => "10. Gêmeas do nado mostram curvas de biquíni", :body => "Reparou no jeito que as duas estendem a canga? Em se tratando das gêmeas do nado, tudo é bonito!" })
article.categories << ruby
article.save

article = user.articles.new({ :title => "11. Daniel Rezende diz que qualidade de Fora de Controle une a televisão ao cinema", :body => "Daniel Rezende é um dos diretores, junto com Johnny Araújo, de Fora de Controle. Os dois e toda a equipe, se empenhou muito para levar até os telespectadores um produto de qualidade." })
article.categories << ruby
article.save

article = user.articles.new({ :title => "12. Deborah Secco passa mal em aeroporto", :body => "Na manhã desta quarta-feira (9), a atriz Deborah Secco foi flagrada do aeroporto Santos Dummont, no Rio de Janeiro" })
article.categories << ruby
article.save

article = user.articles.create({
  :title => "2º Café com Java – Teste de Integração com DbUnit e jIntegrity",
  :body => '
  Hi! My name is **Washington Botelho** and this article is a example of [Markdown](http://daringfireball.net/projects/markdown/ "Markdown") using [Redcarpet](https://github.com/tanoku/redcarpet "Redcarpet") and [Pygements.rb](https://github.com/tmm1/pygments.rb "Pygments.rb").

  We can apply a Ruby *Syntax Highlighting* in a block like the following:

  ```ruby
  def hello_world
    puts "Hello World!"
  end
  ```

  <!--more-->

  Or to user other language like Java:

  ```java
  public static void main(String args[]) {
      System.out.println("Hello World!");
  }
  ```

  Well, I think you understood, then it finish here!
  
  Bye!
' })
article.categories << [java, test]
article.save

comment1 = article.comments.create({
  :name => "Fábio",
  :email => "fabio@gmail.com",
  :url => "http://codereverse.blogspot.com",
  :body => "Não conhecia DBUnit antes dessa palestra.\nIsso com certeza vai ajudar em muito nos meus testes.\n\nvalews!"
})

  response1 = article.comments.create({
    :name => "Washington Botelho",
    :email => "wbotelhos@gmail.com",
    :url => "http://wbotelhos.com.br",
    :body => "Fala Fábio,\nEle é quase que obrigatório para os testes de Integração e com a ajuda do jIntegrity fica izi! (:",
    :comment_id => comment1.id
  })

    article.comments.create({
      :name => "Fábio",
      :email => "fabio@gmail.com",
      :url => "http://codereverse.blogspot.com",
      :body => "Certamente utilizarei. Abraço.",
      :comment_id => response1.id
    })

comment2 = article.comments.create({
  :name => "Daniel Faria",
  :email => "danielfariati@gmail.com",
  :url => "http://danielfariati.com.br",
  :body => "Muito boas as palestras.\nA de Vraptor já era de se esperar que seria muito boa, a de DbUnit com ajuda do jIntegrity foi ótima, ótimo framework.\nQuem não foi perdeu uma passagem de conhecimentos muito importante."
})

  article.comments.create({
    :name => "Washington Botelho",
    :email => "wbotelhos@gmail.com",
    :url => "http://wbotelhos.com.br",
    :body => "Valeu Daniel.\nO Lucas realmente manda muito bem nas apresentações.\nQue bom que gostou do jIntegrity, espero que o utilize.",
    :comment_id => comment2.id
  })
