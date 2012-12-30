module SocialHelper
  def author_social(user)
    ''.tap do |html|
      html << social_link_for(user.github, 'github')
      html << social_link_for(user.linkedin, 'linkedin')
      html << social_link_for(user.twitter, 'twitter')
      html << social_link_for(user.facebook, 'facebook')
    end
  end

  def social_icon(icon, title, path)
    link_to image_tag(icon, alt: title, title: title), path, target: '_blank'
  end

  private

  def social_link_for(social, clazz)
    social.present? ? link_to('', social, title: social, target: '_blank', class: clazz) : ''
  end
end
