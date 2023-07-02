---
date: 2012-09-24T00:00:00-03:00
description: 'Design Responsivo com o "Responsive Design View" do Firefox'
tags: ["firefox", "responsive", "design", "view"]
title: 'Design Responsivo com o "Responsive Design View" do Firefox'
---

Com a modernização da web e a vasta gama de *smartphones* no mercado, é quase inaceitável um site que não apresente seu conteúdo de forma legível em diferentes dispositivos. Com isso o chamado [Responsive Design](http://pt.wikipedia.org/wiki/Web_Design_Responsivo) tomou conta do mercado e hoje é uma estratégia chave para o sucesso de qualquer aplicação.

# Objetivo

Apresentar e configurar a opção *Responsive Design View* do [Firefox](http://firefox.com) para um melhor desenvolvimento.

# O que é?

Uma ferramenta que te deixa modificar o tamanho da tela do navegador onde você pode ver como ficará o seu site em diferentes tamanhos como em um celular ou em um *tablet*. O melhor é que podemos mudar o tamanho da tela internamente ao *browser* sem precisar, de fato, redimensionar a janela como um todo. Sendo assim, o [Firebug](https://getfirebug.com) fica em seu tamanho real livre para uso. Além disso podemos facilmente rotacionar a tela, simular um *touch*, tirar *screenshot* ou configurar tamanhos de tela pré-definidos.

# Acessando a ferramenta

Podemos utilizar o menu: `Tools > Web Developer > Responsive Design View` (inglês) ou usar o atalho `alt + command + M` (mac). Você verá a seguinte tela:

<a href="https://www.flickr.com/photos/wbotelhos/15057008327" title="design-responsivo-com-o-responsive-design-view-do-firefox-2">
<img class="align-center" src="https://farm6.staticflickr.com/5581/15057008327_9aa487d23d.jpg" width="500" height="262" alt="design-responsivo-com-o-responsive-design-view-do-firefox-2"></a>


1. Redimensionar a tela na vertical;
2. Redimensionar a tela na horizontal;
3. Redimensionar a tela na diagonal;
4. Fechar o modo Responsive Design View;
5. Girar a tela;
6. Simular um toque na tela (touch);
7. Download de uma screenshot da tela interna;
8. Escolher tamanhos de telas pré definidos:

<a href="https://www.flickr.com/photos/wbotelhos/15240727101" title="design-responsivo-com-o-responsive-design-view-do-firefox-3 by Washington Botelho, on Flickr">
<img class="align-center" src="https://farm6.staticflickr.com/5582/15240727101_f49099fc4b.jpg" width="431" height="500" alt="design-responsivo-com-o-responsive-design-view-do-firefox-3"></a>

Veja que por estarmos com uma opção selecionada, o último item se transforma em uma opção de remoção *Remove Present*. Se você quiser criar um tamanho personalizado, basta selecionar a primeira opção *...x... (custom)*, onde as reticências é o último valor escolhido. Assim a última opção se tornará *Add Present* que ao clicar abre uma caixa para digitar as medidas.

Você pode criar um array de objetos no formato JSON para especificar todos os tamanhos que desejar. Depois de um tempo você acaba usando os mesmos break points. O meus são:

```json
[
  { "key": "240x320"  , "name": "Crappy Android portrait"            , "width": 240  , "height": 320  },
  { "key": "240x320"  , "name": "Crappy Android portrait"            , "width": 240  , "height": 320  },
  { "key": "320x240"  , "name": "Crappy Android landscape"           , "width": 320  , "height": 240  },
  { "key": "320x480"  , "name": "iPhone 3+4 portrait"                , "width": 320  , "height": 480  },
  { "key": "480x320"  , "name": "iPhone 3+4 landscape"               , "width": 480  , "height": 320  },
  { "key": "320x568"  , "name": "iPhone 5 portrait"                  , "width": 320  , "height": 568  },
  { "key": "568x320"  , "name": "iPhone 5 landscape"                 , "width": 568  , "height": 320  },
  { "key": "380x685"  , "name": "Android (Samsung Galaxy) portrait"  , "width": 380  , "height": 685  },
  { "key": "685x380"  , "name": "Android (Samsung Galaxy) landscape" , "width": 685  , "height": 380  },
  { "key": "600x1024" , "name": "Kindle portrait"                    , "width": 600  , "height": 1024 },
  { "key": "1024x600" , "name": "Kindle landscape"                   , "width": 1024 , "height": 600  },
  { "key": "768x1024" , "name": "iPad portrait"                      , "width": 768  , "height": 1024 },
  { "key": "1024x678" , "name": "iPad landscape"                     , "width": 1024 , "height": 768  }
]
```

1. Copie o array de dados acima;
2. Digite `about:config` na barra de endereços e aperte enter;
3. No campo de busca, procure pela palavra `presets` e dê dois cliques no item `devtools.responsiveUI.presets`;
4. Será disponibilizado uma caixa entrada dos dados, logo cole o código copiado no item 1 e clique em ok.

Pronto, você já configurou tudo, bastanto desativar e reativar, a opção "Responsive Design View", para que as alterações sejam aplicadas. Existem vários sites que simulam os tamanhos de telas, o que mais gosto é o [responsinator.com](responsinator.com), onde é possível especificar a url `localhost:3000`, por exemplo, e visualizar tudo a partir da sua máquina.
