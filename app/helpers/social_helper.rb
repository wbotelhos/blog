module SocialHelper
  def author_social(user)
    ''.tap do |html|
      html << social_link_for(user.github, 'github')
      html << social_link_for(user.linkedin, 'linkedin')
      html << social_link_for(user.twitter, 'twitter')
      html << social_link_for(user.facebook, 'facebook')
    end
  end

  def twitter_button(options = {})
    options = {
      text:  %("#{options[:text]}"),
      url:   options[:url],
      via:   'wbotelhos'
    }

    link = link_to 'Tweet', "https://twitter.com/intent/tweet?#{to_query options}", target: '_blank'

    content_tag :div, link, id: 'twitter'
  end

  def social_icon(text, clazz, path) #
    link_to '', path, alt: "#{text} <#{path}>", title: "#{text} <#{path}>", target: '_blank', class: clazz
  end

  private

  def to_query(options)
    options.map { |key, value| "#{key}=#{CGI.escape value}" }.join '&'
  end

  def social_link_for(social, clazz)
    social.present? ? link_to('', social, title: social, target: '_blank', class: clazz) : ''
  end
end
