module SocialHelper
  def author_social(user)
    ''.tap do |html|
      html << social_link_for(user.github, 'github')
      html << social_link_for(user.linkedin, 'linkedin')
      html << social_link_for(user.twitter, 'twitter')
      html << social_link_for(user.facebook, 'facebook')
    end
  end

  def social_icon(text, clazz, path) #
    link_to '', path, alt: "#{text} <#{path}>", title: "#{text} <#{path}>", target: '_blank', class: clazz
  end

  private

  def social_link_for(social, clazz)
    social.present? ? link_to('', social, title: social, target: '_blank', class: clazz) : ''
  end
end
