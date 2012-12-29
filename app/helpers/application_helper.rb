module ApplicationHelper
  def author(user)
    ''.html_safe.tap do |html|
      html << gravatar(user.email, { alt: '', title: user.name })
      html << (content_tag :div, simple_format(user.bio.html_safe), class: 'biography' if user.bio)
      html << (content_tag :div, author_social(user).html_safe, class: 'social')
    end
  end

  def gravatar(email, options = {})
    hash = Digest::MD5.hexdigest(email)

    url = "http://www.gravatar.com/avatar/#{hash}?d=mm"
    url << "&s=#{options[:size]}" unless options[:size].nil?

    image_tag url, options
  end

  def logo
    h1 = content_tag :h1, link_to(CONFIG['author'], root_path)
    pe = content_tag :p, CONFIG['description']

    content_tag :div, h1 + pe, id: 'logo'
  end

  def markdown(content)
    renderer = HTMLwithPygments.new(hard_wrap: true) # filter_html: true

    options = {
      autolink:           true,
      no_intra_emphasis:  true,
      fenced_code_blocks: true,
      lax_html_blocks:    true,
      strikethrough:      true,
      superscript:        true
    }

    Redcarpet::Markdown.new(renderer, options).render(content).html_safe
  end

  private

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language, options: { encoding: 'utf-8' })
    end
  end
end
