class CommentMailer
  def initialize(article, new_comment)
    @article = article
    @new_comment = new_comment
  end

  def send
    @article.unique_comments.each do |comment|
      Mailer.comment(@article, @new_comment, comment).deliver
    end

    Mailer.comment_notify(@article, @new_comment).deliver
  end
end
