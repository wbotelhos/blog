# frozen_string_literal: true

class ArticlePresenter < SimpleDelegator
  def content
    HighlighterService.highlight(body)
  end

  def self.wrap(articles)
    articles.map { |article| new(article) }
  end
end
