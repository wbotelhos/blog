module ArticleHelper
  def article_slug(article, anchor = nil)
    article_path(article.year, article.month, article.day, article.slug, anchor: anchor)
  end

  def article_slug_url(article, anchor = nil)
    article_url(article.year, article.month, article.day, article.slug, anchor: anchor)
  end
end
