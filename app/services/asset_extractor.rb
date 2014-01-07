class AssetExtractor
  class Url
    attr_reader :base_url, :url

    def initialize(base_url, url)
      @base_url = base_url
      @url      = url
    end

    def to_s
      if @url =~ %r(\Ahttps?://)i
        @url
      elsif @url.starts_with? '//'
        "http:#{url}"
      else
        File.join @base_url, @url
      end
    end
  end

  def initialize(media, response)
    @html  = Nokogiri::HTML response.body
    @media = media
  end

  def process
    # extract_labs
    # extract_plugin
    # extract_index
    extract_favicon
  end

  def extract_labs
    @html.css('link[href*="labs"], script[src*="labs"], link[href*="demo"], script[src*="demo"]').each do |tag|
      attribute = url_attribute tag
      url       = Url.new(CONFIG['url_http'], tag[attribute]).to_s

      return if @url =~ %r(\Ahttps)i

      filename       = get_filename url
      destiny        = Rails.root.join 'public', @media.slug, 'demo', filename
      tag[attribute] = "demo/#{filename}"

      save_asset! url, filename, destiny
    end
  end

  def extract_favicon
    @html.css('link[href*=".ico"]').each do |tag|
      attribute = url_attribute tag
      url       = Url.new(CONFIG['url_http'], tag[attribute]).to_s

      puts '>' * 100
      p url
      puts '<' * 100
      return if @url =~ %r(\Ahttps)i

      filename       = get_filename url
      destiny        = Rails.root.join 'public', @media.slug, 'demo', filename
      tag[attribute] = "demo/#{filename}"

      puts '>' * 100
      p tag
      puts '<' * 100
      save_asset! url, filename, destiny
    end
  end

  def extract_plugin
    @html.css('link[href*="lib"], script[src*="lib"]').each do |tag|
      attribute = url_attribute tag
      url       = Url.new(CONFIG['url_http'], tag[attribute]).to_s

      return if @url =~ %r(\Ahttps)i

      filename       = get_filename url
      destiny        = Rails.root.join 'public', @media.slug, 'lib', filename
      tag[attribute] = "lib/#{filename}"

      save_asset! url, filename, destiny
    end
  end

  def extract_index
    destiny = Rails.root.join 'public', @media.slug, 'demo.html'

    File.open(destiny, 'wb') do |file|
      file << @html.to_html
    end
  end

  def save_asset!(url, filename, destiny)
    p "FROM: #{url}"
    p "TO: #{destiny}"

    FileUtils.mkdir_p destiny.dirname

    File.open(destiny, 'wb') do |file|
      file << Aitch.get(url).body
    end
  end

  private

  def get_filename(url)
    filename  = url.split('/').last
    name, md5 = filename.split '-'

    if md5
      extension = File.extname URI.parse(url).path
      filename  = "#{name}#{extension}"
    end

    p "FILENAME: #{filename}"

    filename
  end

  def url_attribute(tag)
    tag.name == 'link' ? 'href' : 'src'
  end
end
