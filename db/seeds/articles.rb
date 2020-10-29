# frozen_string_literal: true

puts "[seed] #{File.basename(__FILE__)}"

@articles = {}

body = <<~HEREDOC
  Hi! My name is **Washington Botelho** and this article is an example to introduce how this Blog project works.

  ### Article

  We are using the [Markdown](https://daringfireball.net/projects/markdown/ "Markdown") syntaxe with help of the [Rouge](https://github.com/rouge-ruby/rouge "Rouge") to make it colorized.

  You can apply a Ruby *Syntax Highlighting* in a block like the following:

  ```ruby
  def hello
    puts 'Hello Markdown!'
  end
  ```

  But if you want to write other language like Java, feel free:

  ```java
  class Hello {

    public static void main(String args[]) {
      System.out.println("Hello Markdown!");
    }

  }
  ```

  ### Code

  We can use HTML inside Markdown:

  <div style="background-color: pink; border-radius: 3; padding: 15px;">This is a DIV element!</div>

  ### Credentials

  You can change the default credentials editing the file `config/config.yml`.

  ### License

  This blog is free under the MIT License, be nice and keep the author's credits. (:

  See you and your blog soon!
HEREDOC

@articles[:first_steps] = create_article(body: body, title: 'First Steps')
@articles[:draft]       = create_article(body: 'First of all...', published_at: nil, title: 'How Can We Improve it?')
