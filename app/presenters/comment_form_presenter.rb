class CommentFormPresenter

  def initialize(article, comment)
    @article = article
    @comment = comment
  end

  def partial
    { :partial => "comments/form", :locals => { :article => @article, :comment => @comment } }
  end 

end
