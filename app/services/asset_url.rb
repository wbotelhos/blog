class AssetUrl
  def initialize(base_url, url)
    @base_url = base_url
    @url      = url
  end

  def to_s
    if %r(\Ahttps?://)i.match?(@url)
      @url
    elsif @url.starts_with? '//'
      "http:#{@url}"
    else
      File.join @base_url, @url
    end
  end
end
