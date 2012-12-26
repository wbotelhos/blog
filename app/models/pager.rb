class Pager
  LIMIT = 10

  attr_reader :options

  def initialize(options = {})
    options[:limit] = options[:limit] || LIMIT
    @options = options
  end

  def page
    value = (options[:params][:page] || 1).to_i
    value = 1 if value <= 0
    value
  end

  def offset
    (page - 1) * options[:limit]
  end

  def has_back?
    page > 1
  end

  def has_next?
    @paged.size > options[:limit]
  end

  def url
    "#{options[:fullpath].split('?')[0]}?page=";
  end

  def back_url
    "#{url}#{page - 1}"
  end

  def next_url
    "#{url}#{page + 1}"
  end

  def paginate
    @paged ||= options[:collection].offset(offset).limit(options[:limit] + 1)
  end
end
