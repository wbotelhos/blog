# frozen_string_literal: true

def create_article(options)
  default = {
    published_at: Time.current,
    user:         @users[:wbotelhos],
  }

  Article.create!(default.merge(options))
end

def create_comment(options)
  default = {}

  Comment.create!(default.merge(options))
end

def create_lab(options)
  default = {
    published_at: Time.current,
  }

  Lab.create!(default.merge(options))
end

def create_user(options)
  default = {
    password:              '123mudar',
    password_confirmation: '123mudar',
  }

  User.create!(default.merge(options))
end
