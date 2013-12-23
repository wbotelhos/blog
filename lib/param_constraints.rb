class ParamConstraints
  def matches?(request)
    @request ||= request

    is_lab? @request.params[:slug]
  end

  def is_lab?(slug)
    Lab.find_by_slug(slug).present?
  end
end
