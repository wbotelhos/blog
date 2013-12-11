# coding: utf-8

categories = []
categories << Category.create!(name: 'Awesome Print')
categories << Category.create!(name: 'Capistrano')
categories << Category.create!(name: 'Capybara')
categories << Category.create!(name: 'FactoryGirl')
categories << Category.create!(name: 'Mail Catcher')
categories << Category.create!(name: 'Pry')
categories << Category.create!(name: 'Pygments')
categories << Category.create!(name: 'Rails')
categories << Category.create!(name: 'Redcarpet')
categories << Category.create!(name: 'Rspec')
categories << Category.create!(name: 'Ruby')
categories << Category.create!(name: 'Sphinx')
categories << Category.create!(name: 'Unicorn')

Link.create! name: 'jIntegrity',              url: 'http://jintegrity.com'
Link.create! name: 'Mockr.me',                url: 'http://mockr.me'
Link.create! name: 'Washington Botelho [US]', url: 'http://wbotelhos.com'
Link.create! name: 'yLabs',                   url: 'http://wbotelhos.com/labs'

user = User.create!(
  bio:                    'Programador metido a designer, ajudante e aprendiz da comunidade open source.',
  email:                  'wbotelhos@gmail.com',
  name:                   'Washington Botelho',
  password:               'password',
  password_confirmation:  'password'
)

Lab.create!(
  description:  'jQuery Raty - A Star Rating Plugin',
  image:        'raty.png'
  name:         'jQuery Raty',
  slug:         'raty',
)

Lab.create!(
  description:  'jQuery Gridy - A Grid Plugin',
  image:        'gridy.png'
  name:         'jQuery Gridy',
  slug:         'gridy',
)

article = user.articles.new(
  title:        'First Steps',
  published_at: Time.now,
  body:         %[
Hi! My name is **Washington Botelho** and this article is an example to introduce how it works.

### Article

We are using the [Markdown](http://daringfireball.net/projects/markdown/ "Markdown") syntaxe with help of the [Redcarpet](https://github.com/tanoku/redcarpet "Redcarpet") and [Pygments.rb](https://github.com/tmm1/pygments.rb "Pygments.rb") to make it colorized.

You can apply a Ruby *Syntax Highlighting* in an block like the following:

```ruby
def hello
  puts 'Hello Markdown!'
end
```

But if you want to write other language linke Java, feel free:

```java
class Hello {

  public static void main(String args[]) {
    System.out.println("Hello Markdown!");
  }

}
```

### Credentials

By default my credentials is written here, but you can change it editing the file config/config.yml.

### Deploy

We using the Capistrano to do it, then check the deploy.rb file to configure your settings.

### License

This blog is free under the MIT License, be nice and keep the author's credits. (:

See you and your blog soon!
])
article.categories = categories
article.save!

comment1 = article.comments.create!(
  body:   "Hi Botelho,\nCould I use your blog?\n\nI really liked it!",
  email:  'glbenz@gmail.com',
  name:   'Gabriel Benz',
  url:    'http://http://gabrielbenz.com'
)

  response1 = article.comments.new(
    body:      'Of course man, just keep the credits. (;',
    email:     'wbotelhos@gmail.com',
    name:      'Washington Botelho',
    parent_id: comment1.id
    url:       'http://wbotelhos.com'
  )
  response1.author = true
  response1.save!

comment2 = article.comments.create!(
  body:   "Hi Washington,\nI would like to contribute to the blog, you agree Pull Requests?",
  email:  'danielfariati@gmail.com',
  name:   'Daniel Faria',
  url:    'http://danielfariati.com.br'
)

  response2 = article.comments.create!(
    body:      "Hi Daniel,\nYour contributions are always welcome my friend.\nI'm waiting for your great code. (:",
    email:     'wbotelhos@gmail.com',
    name:      'Washington Botelho',
    parent_id: comment2.id,
    url:       'http://wbotelhos.com'
  )
  response2.author = true
  response2.save!

    article.comments.create!(
      name:      'Daniel Faria',
      email:     'danielfariati@gmail.com',
      url:       'http://danielfariati.com.br',
      body:      "Yeah! I'll pull it soon.",
      parent_id: response2.id
    )

Donator.create!(
  amount:  60.0,
  country: 'Macapá',
  email:   'madsonmac@gmail.com',
  message: 'Good job on blog and the jQuery plugins. Thanks for your work!',
  name:    'Madson Cardoso',
  url:     'http://madsonmac.com'
)

Donator.create!(
  amount:  30.0,
  country: 'Gaúcho',
  email:   'lenon.marcel@gmail.com',
  message: 'Nonononon. Thanks!',
  name:    'Lenon Marcelo',
  url:     'http://lenonmarcel.com.br'
)
