# frozen_string_literal: true

class AssetUrl
  def initialize(base_url, url)
    @base_url = base_url
    @url      = url
  end

  def to_s
    return @url           if %r(\Ahttps?://)i.match?(@url)
    return "http:#{@url}" if @url.starts_with?('//')

    File.join(@base_url, @url)
  end
end
