# coding: utf-8

user = User.create!(
  email:                 'wbotelhos@gmail.com',
  name:                  'Washington Botelho',
  password:              'password',
  password_confirmation: 'password'
)

Lab.create!(
  description: 'jQuery Raty - A Star Rating Plugin',
  image:       'raty.png',
  name:        'jQuery Raty',
  slug:        'raty'
)

Lab.create!(
  description: 'jQuery Gridy - A Grid Plugin',
  image:       'gridy.png',
  name:        'jQuery Gridy',
  slug:        'gridy'
)

article = user.articles.new(
  published_at: Time.now,
  title:        'First Steps',
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
article.save!

comment_1 = article.comments.create!(
  body:  "Hi Botelho,\nCould I use your blog?\n\nI really liked it!",
  email: 'glbenz@gmail.com',
  name:  'Gabriel Benz',
  url:   'http://gabrielbenz.com'
)

  response_1 = article.comments.new(
    body:      'Of course man, just keep the credits. (;',
    email:     'wbotelhos@gmail.com',
    name:      'Washington Botelho',
    parent_id: comment_1.id,
    url:       'http://wbotelhos.com'
  )
  response_1.author = true
  response_1.save!

comment_2 = article.comments.create!(
  body:  "Hi Washington,\nI would like to contribute to the blog, you agree Pull Requests?",
  email: 'danielfariati@gmail.com',
  name:  'Daniel Faria',
  url:   'http://danielfariati.com.br'
)

  response2 = article.comments.create!(
    body:      "Hi Daniel,\nYour contributions are always welcome my friend.\nI'm waiting for your great code. (:",
    email:     'wbotelhos@gmail.com',
    name:      'Washington Botelho',
    parent_id: comment_2.id,
    url:       'http://wbotelhos.com'
  )
  response2.author = true
  response2.save!

    article.comments.create!(
      body:      "Yeah! I'll pull it soon.",
      email:     'danielfariati@gmail.com',
      name:      'Daniel Faria',
      parent_id: response2.id,
      url:       'http://danielfariati.com.br'
    )
