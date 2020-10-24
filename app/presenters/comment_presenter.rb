# frozen_string_literal: true

class CommentPresenter < SimpleDelegator
  def content
    HighlighterService.highlight(body)
  end

  def self.wrap(comments)
    comments.map { |comment| new(comment) }
  end
end
