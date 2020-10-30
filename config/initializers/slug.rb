# frozen_string_literal: true

class String
  def slug
    return '' if blank?

    from = 'áàãâäèéêëìíîïõòóôöùúûüç'
    to   = 'aaaaaeeeeiiiiooooouuuuc'

    slug = downcase

    slug.gsub!(/\s-\s/, '-')
    slug.gsub!(/\s/, '-')
    slug.tr! from, to
    slug.gsub!(/[^\w-]/, '')
    slug.sub!(/^-/, '')
    slug.gsub!(/-$/, '')

    slug
  end
end
