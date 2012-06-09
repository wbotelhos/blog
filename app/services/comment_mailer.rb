class CommentMailer

  def initialize(article, new_comment)
    @article = article
    @new_comment = new_comment
  end

  def send
    comments = @article.unique_comments

    comments.each do |comment|
      Mailer.comment(@article, @new_comment, comment).deliver
    end
  end

end
