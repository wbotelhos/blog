class Mailer < ActionMailer::Base

  default :from => "noreply@wbotelhos.com.br"

  def comment(article, new_comment, comment)
    @article = article
    @new_comment = new_comment
    @comment = comment

    mail :to => comment[:email], :subject => t("mail.comment.responded"), :bcc => "wbotelhos@gmail.com" do |format|
      format.text
    end
  end

end
