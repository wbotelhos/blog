module ApplicationHelper
  def errors_for(object, key)
    errors = object.errors.messages[key]

    content_tag(:span, errors[0], class: 'validation-error') if errors.present?
  end

  def gravatar(email, options = {})
    hash = Digest::MD5.hexdigest(email)
    url  = "http://www.gravatar.com/avatar/#{hash}?d=mm"

    url << "&s=#{options[:size]}" if options[:size]

    options[:alt] = '' if options[:alt].nil?

    image_tag url, options
  end

  def markdown(content)
    renderer = HTMLwithPygments.new hard_wrap: true

    options = {
      autolink:           true,
      fenced_code_blocks: true,
      lax_html_blocks:    true,
      no_intra_emphasis:  true,
      strikethrough:      true,
      superscript:        true
    }

    Redcarpet::Markdown.new(renderer, options).render(content).html_safe
  end

  def menu_icon(text, clazz, path)
    link_to '', path, title: text, class: clazz
  end

  def social_icon(text, clazz, path)
    text = "#{text} <#{path.gsub /mailto:/, ''}>"

    link_to '', path, title: text, target: :_blank, class: clazz
  end

  def time_ago(time)
    value = t('comment.created_at', time: time_ago_in_words(time))

    content_tag :abbr, value, title: time.getutc.iso8601 if time
  end

  private

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language, options: { encoding: 'utf-8' })
    end
  end
end
