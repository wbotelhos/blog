# frozen_string_literal: true

@comments = {}

@comments[:comment_1] = create_comment(
  body:        "Hi Botelho,\nCould I use your blog?\n\nI really liked it!",
  commentable: @articles[:first_steps],
  email:       'glbenz@example.com',
  name:        'Gabriel Benz',
  url:         'https://gabrielbenz.com'
)

@comments[:comment_1_1] = create_comment(
  author:      true,
  body:        'Of course man, just keep the credits. (;',
  commentable: @articles[:first_steps],
  email:       'wbotelhos@example.com',
  name:        'Washington Botelho',
  parent:      @comments[:comment_1],
  url:         'https://www.wbotelhos.com'
)

@comments[:comment_2] = create_comment(
  body:        "Hi Washington,\nI would like to contribute to the blog, you agree Pull Requests?",
  commentable: @articles[:first_steps],
  email:       'danielfariati@example.com',
  name:        'Daniel Faria',
  url:         'https://danielfariati.com.br'
)

@comments[:comment_2_1] = create_comment(
  author:      true,
  body:        "Hi Daniel,\nYour contributions are always welcome my friend.\nI'm waiting for your great code. (:",
  commentable: @articles[:first_steps],
  email:       'wbotelhos@example.com',
  name:        'Washington Botelho',
  parent:      @comments[:comment_2],
  url:         'https://www.wbotelhos.com'
)

@comments[:comment_2_1_1] = create_comment(
  body:        "Yeah! I'll pull it soon.",
  commentable: @articles[:first_steps],
  email:       'danielfariati@example.com',
  name:        'Daniel Faria',
  parent:      @comments[:comment_2_1],
  url:         'https://danielfariati.com.br'
)
