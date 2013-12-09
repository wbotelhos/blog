# coding: utf-8

module ApplicationHelper
  # workaround to simulate the form_builder that does not works.
  def errors_for(object, key)#
    errors = object.errors.messages[key]

    content_tag(:span, errors[0], class: 'validation-error') if errors.present?
  end

  def menu_icon(text, clazz, path) #
    link_to '', path, alt: text, title: text, class: clazz
  end

  def social_icon(text, clazz, path) #
    text = "#{text} <#{path.gsub /mailto:/, ''}>"

    link_to '', path, alt: text, title: text, target: :_blank, class: clazz
  end

  def author(user)
    ''.html_safe.tap do |html|
      html << gravatar(user.email, alt: '', title: user.name)
      html << (content_tag :div, simple_format(user.bio.html_safe), class: 'biography' if user.bio)
      html << (content_tag :div, author_social(user).html_safe, class: 'social')
    end
  end

  def gravatar(email, options = {})
    hash = Digest::MD5.hexdigest(email)

    url = "http://www.gravatar.com/avatar/#{hash}?d=mm"
    url << "&s=#{options[:size]}" if options[:size]

    options[:alt] = '' if options[:alt].nil?

    image_tag url, options
  end

  def logo
    h1 = content_tag :h1, link_to(CONFIG['author'], root_path)
    pe = content_tag :p, CONFIG['description']

    content_tag :div, h1 + pe, id: 'logo'
  end

  def markdown(content)
    renderer = HTMLwithPygments.new hard_wrap: true # filter_html: true

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

  def donate_button(item_name = 'wbotelhos.com')
    url = "https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X8HEP2878NDEG&item_name=#{item_name}"
    label = content_tag(:i, nil, class: 'icon-heart-empty') + t('navigation.donate')

    link_to label, url, id: 'donate', target: '_blank'
  end

  def time_ago(time)#
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
