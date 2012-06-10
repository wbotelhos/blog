class Mailer < ActionMailer::Base

  default :from => %[noreply@#{CONFIG["url"]}]

  def comment(article, new_comment, comment)
    @article = article
    @new_comment = new_comment
    @comment = comment

    mail :to => comment.email, :subject => "Artigo respondido", :bcc => CONFIG["email"] do |format|
      format.html
      format.text
    end
  end

end
