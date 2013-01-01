# coding: utf-8

class Mailer < ActionMailer::Base
  default from: CONFIG['email']

  def comment(article, new_comment, comment)
    @article, @new_comment, @comment = article, new_comment, comment

    mail to: comment.email, subject: "Artigo respondido por #{new_comment.name}" do |format|
      format.html
      format.text
    end
  end

  def comment_notify(article, comment)
    @article, @comment = article, comment

    mail to: article.user.email, subject: "Comentário do #{comment.name} pendente no blog!"
  end
end
