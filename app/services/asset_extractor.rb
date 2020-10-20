class AssetExtractor
  def initialize(media, response)
    @html  = Nokogiri::HTML response.body
    @media = media
  end

  def extract_html
    destiny = join_path 'demo/index.html'
    html    = @html.to_html
    html    = fix_favicon html
    html    = fix_lib_path html
    html    = fix_public_path html

    write_file destiny, html
  end

  def extract(elements, path)
    @html.css(elements).each do |tag|
      attribute      = url_attribute tag
      url            = get_url tag[attribute]
      filename       = get_filename url
      type           = expand_filename filename
      folder         = [path, type].compact.join('/')
      tag[attribute] = "#{folder}/#{filename}"
      destiny        = join_path 'demo', folder, filename

      save_file! url, destiny, filename
    end
  end

  def remove_elements
    @html.at_css('form').remove
    @html.at_css('meta[name="csrf-token"]').remove
    @html.search('.reply').map(&:remove)
    @html.search('//abbr').map(&:remove)
  end

  def process
    extract 'link[href*="labs"] , script[src*="labs"]', nil

    remove_elements

    extract_html
  end

  def save_file!(url, destiny, filename)
    FileUtils.mkdir_p destiny.dirname

    body = Aitch.get(url).body.force_encoding('binary')

    body = rename_fonts body if filename == 'labs.css'

    write_file destiny, body
  end

  private

  def expand_filename(filename)
    match = filename.match(/labs.+(css|js)$/)

    return nil if match.blank?

    match.captures.first == 'css' ? 'stylesheets' : 'javascripts'
  end

  def fix_favicon(html)
    html.sub! '//blogy.s3.amazonaws.com/favicon.ico', 'favicon.ico'
  end

  def fix_lib_path(html)
    html.gsub! 'lib/', '../lib/'
    html.gsub! 'vendor/', '../vendor/'
  end

  def fix_public_path(html)
    html.gsub!(%r(raty/), '')
  end

  def get_filename(url)
    filename  = url.split('/').last
    name, md5 = filename.split '-'

    if md5
      extension = File.extname URI.parse(url).path
      filename  = "#{name}#{extension}"
    end

    filename
  end

  def get_url(value)
    AssetUrl.new(CONFIG['url_http'], value).to_s
  end

  def join_path(*paths)
    Rails.root.join 'public', @media.slug, paths.join('/')
  end

  def rename_fonts(body)
    body.gsub!('//blogy.s3.amazonaws.com/assets', '../fonts')

    # "#{$1}.#{$2}" does not works
    %w[eot svg ttf woff].each do |ext|
      body.gsub!(/(blogy)-.+\.(#{ext})/, "blogy.#{ext}")
    end

    body
  end

  def url_attribute(tag)
    tag.name == 'link' ? 'href' : 'src'
  end

  def write_file(destiny, content)
    File.open(destiny, 'wb') { |f| f << content }
  end
end
