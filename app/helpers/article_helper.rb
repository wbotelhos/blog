# frozen_string_literal: true

module ArticleHelper
  def published_at(article)
    l article.published_at || article.created_at
  end
end
