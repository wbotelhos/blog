require "net/smtp"

module Net
  class SMTP
    def tls?
      Rails.env.production?
    end
  end
end
