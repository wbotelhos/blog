# frozen_string_literal: true

class LabPresenter < SimpleDelegator
  def content
    HighlighterService.highlight(body)
  end

  def page_title
    "#{title} | #{description}"
  end
end
