class ParamConstraints
  def matches?(request)
    @request ||= request

    is_lab? @request.params[:slug]
  end

  def is_lab?(value)
    CONFIG['labs'].split(',').include? value
  end
end
