class Mailer < ActionMailer::Base

  default :from => "Washington Botelho <noreply@wbotelhos.com.br>"

  def comment(option = {})
    @option = option

    mail :to => option[:email], :subject => t("mail.comment.responded") do |format|
      format.text
    end
  end

end
