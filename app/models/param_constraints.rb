# frozen_string_literal: true

class ParamConstraints
  def matches?(request)
    is_lab? request.params[:slug]
  end

  def is_lab?(slug)
    Lab.exists? slug: slug
  end
end
