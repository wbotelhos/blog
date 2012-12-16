# coding: utf-8

categories = []
categories << Category.create!({ name: 'Awesome Print' })
categories << Category.create!({ name: 'Capistrano' })
categories << Category.create!({ name: 'Capybara' })
categories << Category.create!({ name: 'FactoryGirl' })
categories << Category.create!({ name: 'Mail Catcher' })
categories << Category.create!({ name: 'Pry' })
categories << Category.create!({ name: 'Pygments' })
categories << Category.create!({ name: 'Rails' })
categories << Category.create!({ name: 'Redcarpet' })
categories << Category.create!({ name: 'Rspec' })
categories << Category.create!({ name: 'Ruby' })
categories << Category.create!({ name: 'Sphinx' })
categories << Category.create!({ name: 'Unicorn' })

Link.create!({ name: 'jIntegrity',              url: 'http://jintegrity.com' })
Link.create!({ name: 'Mockr.me',                url: 'http://mockr.me' })
Link.create!({ name: 'Washington Botelho [US]', url: 'http://wbotelhos.com' })
Link.create!({ name: 'yLabs',                   url: 'http://wbotelhos.com/labs' })

user = User.create!({
  name:                   'Washington Botelho',
  email:                  'wbotelhos@gmail.com',
  bio:                    %(Desenvolvedor Java, Ruby e Python no Portal <a href="http://r7.com" target="_blank">R7.com</a>.\nÉ Bacharel em Sistemas de Informação e certificado OCJA 1.0 e OCJP 6.\nAjudante e aprendiz da comunidade open source e metido a designer.\n Além disso é apaixonado pela dança, skate, jiu-jitsu e Counter Strike Source. (:)),
  github:                 'http://github.com/wbotelhos',
  twitter:                'http://twitter.com/wbotelhos',
  linkedin:               'http://linkedin.com/in/wbotelhos',
  facebook:               'http://facebook.com/wbotelhos',
  password:               'password',
  password_confirmation:  'password'
})

Lab.create!({
  name:         'jQuery Raty',
  slug:         'raty',
  description:  'jQuery Raty - A Star Rating Plugin',
  image:        'raty.png'
})

Lab.create!({
  name:         'jQuery Gridy',
  slug:         'gridy',
  description:  'jQuery Gridy - A Grid Plugin',
  image:        'gridy.png'
})

article = user.articles.new({
  title:        'First Steps',
  published_at: Time.now,
  body:         %[
Hi! My name is **Washington Botelho** and this article is an example to introduce how it works.

### Article

We are using the [Markdown](http://daringfireball.net/projects/markdown/ "Markdown") syntaxe with help of the [Redcarpet](https://github.com/tanoku/redcarpet "Redcarpet") and [Pygments.rb](https://github.com/tmm1/pygments.rb "Pygments.rb") to make it colorized.

We can apply a Ruby *Syntax Highlighting* in an block like the following:

```ruby
def hello
  puts 'Hello Markdown!'
end
```

Here teminates the resume.

<!--more-->

But if you want to write other language linke Java, feel free:

```java
class Hello {

  public static void main(String args[]) {
    System.out.println("Hello Markdown!");
  }

}
```

### Credentials

By default my credentials is written here, but wit you will run this blog, just edit the file `config/config.yml` and set your data.

### Deploy

We using the Capistrano to do it, then check the deploy.rb file to configure your settings.

### License

This blog is free under the MIT License, then be nice and keep the author's credits. (:

See you and your blog soon!
]})
article.slug = 'first-steps'
article.categories = categories
article.save!

comment1 = article.comments.create!({
  name:   'Gabriel Benz',
  email:  'glbenz@gmail.com',
  url:    'http://http://gabrielbenz.com',
  body:   "Hi Botelho,\nCould I use your blog?\n\nI really liked it!"
})

  response1 = article.comments.new({
    name:       'Washington Botelho',
    email:      'wbotelhos@gmail.com',
    url:        'http://wbotelhos.com.br',
    body:       'Of course man, just keep the credits. (;',
    comment_id: comment1.id
  })
  response1.author = true
  response1.save!

comment2 = article.comments.create!({
  name:   'Daniel Faria',
  email:  'danielfariati@gmail.com',
  url:    'http://danielfariati.com.br',
  body:   "Hi Washington,\nI would like to contribute to the blog, you agree Pull Requests?"
})

  response2 = article.comments.create!({
    name:       'Washington Botelho',
    email:      'wbotelhos@gmail.com',
    url:        'http://wbotelhos.com.br',
    body:       "Hi Daniel,\nYour contributions are always welcome my friend.\nI'm waiting for your great code. (:",
    comment_id: comment2.id
  })
  response2.author = true
  response2.save!

    article.comments.create!({
      name:       'Daniel Faria',
      email:      'danielfariati@gmail.com',
      url:        'http://danielfariati.com.br',
      body:       "Yeah! I'll pull it soon.",
      comment_id: response2.id
    })
