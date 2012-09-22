class CommentMailer
  def initialize(article, new_comment, logger)
    @article, @new_comment, @logger = article, new_comment, logger
  end

  def send
    comments = @article.unique_comments
    @logger.info "Sending mail to: [#{comments.map(&:email).to_sentence}]"

    comments.each do |comment|
      Mailer.comment(@article, @new_comment, comment).deliver
    end

    Mailer.comment_notify(@article, @new_comment).deliver
  end
end
