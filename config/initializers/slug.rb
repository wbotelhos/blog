# coding: utf-8

class String
  def slug
    return '' if self.blank?

    from  = 'áàãâäèéêëìíîïõòóôöùúûüç'
    to    = 'aaaaaeeeeiiiiooooouuuuc'

    slug = self.downcase

    slug.gsub!  /\s-\s/,  '-'
    slug.gsub!  /\s/,     '-'
    slug.tr!    from,     to
    slug.gsub!  /[^\w-]/, ''
    slug.gsub!  /-$/,     ''

    slug
  end
end

