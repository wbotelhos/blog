class Mailer < ActionMailer::Base
  default :from => CONFIG["email"]

  def comment(article, new_comment, comment)
    @article = article
    @new_comment = new_comment
    @comment = comment

    mail :to => comment.email, :subject => "Artigo respondido" do |format|
      format.html
      format.text
    end
  end

  def comment_notify(article, comment)
    @article = article
    @comment = comment

    mail :to => article.user.email, :subject => "Artigo respondido" do |format|
      format.text
    end
  end
end
