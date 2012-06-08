class CommentMailer

  def initialize(comment, url)
    @comment = comment
    @url = url
  end

  def send
    options = @comment.article.unique_comments

    options.each do |option|
      Mailer.comment(option).deliver
    end
  end

end
