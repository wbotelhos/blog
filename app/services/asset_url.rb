class AssetUrl
  def initialize(base_url, url)
    @base_url = base_url
    @url      = url
  end

  def to_s
    if @url =~ %r(\Ahttps?://)i
      @url
    elsif @url.starts_with? '//'
      "http:#{@url}"
    else
      File.join @base_url, @url
    end
  end
end
