module ApplicationHelper
  def errors_for(object, key)
    errors = object.errors.messages[key]

    tag.span(errors[0], class: 'validation-error') if errors.present?
  end

  def github
    "http://github.com/#{CONFIG['github']}"
  end

  def gravatar(email, options = {})
    hash = Digest::MD5.hexdigest(email)
    url  = avatar_image hash, options

    options[:alt] = '' if options[:alt].nil?

    image_tag url, options
  end

  def linkedin
    "http://linkedin.com/in/#{CONFIG['linkedin']}"
  end

  def media_slug(media, anchor = nil)
    slug_path(media.slug, anchor: anchor)
  end

  def media_slug_url(media, anchor = nil)
    slug_url(media.slug, anchor: anchor)
  end

  def menu_icon(text, clazz, path)
    link_to '', path, title: text, class: clazz
  end

  def social_icon(text, clazz, path)
    text = "#{text} <#{path.gsub(/mailto:/, '')}>"

    link_to '', path, title: text, target: :_blank, class: clazz, rel: :noopener
  end

  def time_ago(time)
    value = t('comment.created_at', time: time_ago_in_words(time))

    tag.abbr(value, title: time.getutc.iso8601) if time
  end

  def twitter
    "http://twitter.com/#{CONFIG['twitter']}"
  end

  def twitter_button(options = {})
    options = {
      text: %("#{options[:text]}" ~),
      url:  options[:url],
      via:  CONFIG['twitter'],
    }

    content = tag.i(nil, class: 'i-twitter')
    link    = link_to content, "https://twitter.com/intent/tweet?#{to_query options}", title: t('share.twitter'), target: :_blank, rel: :noopener

    tag.div(link, class: :twitter)
  end

  private

  def avatar_image(hash, options)
    if Rails.env.production?
      url = "http://www.gravatar.com/avatar/#{hash}?d=mm"
      url << "&s=#{options[:size]}" if options[:size]
      url
    else
      'avatar.jpg'
    end
  end

  def to_query(options)
    options.map { |key, value| "#{key}=#{CGI.escape value}" }.join '&'
  end
end
