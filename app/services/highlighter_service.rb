# frozen_string_literal: true

module HighlighterService
  module_function

  def highlight(text)
    Redcarpet::Markdown.new(renderer, extensions).render(text)
  end

  def extensions
    {
      autolink:           true,
      fenced_code_blocks: true,
      lax_html_blocks:    true,
      lax_spacing:        true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true,
    }
  end

  def renderer
    Html.new(
      filter_html:     false,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow' },
    )
  end
end
