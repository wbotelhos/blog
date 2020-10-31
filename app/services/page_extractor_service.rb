# frozen_string_literal: true

class PageExtractorService
  def initialize(media, content, host)
    @html  = Nokogiri::HTML(content)
    @media = media
    @host  = host
  end

  def extract_html
    remove_elements!

    content = rename_favicon(@html.to_s)
    content = rename_css(content)
    content = rename_jquery(content)
    content = rename_js(content)
    content = rename_image(content)
    content = rename_plugin(content)
    target  = join_paths('demo/index.html')

    write_file(target, content)
  end

  def fetch(url)
    Aitch.get(url).body.force_encoding('binary')
  end

  def files_for_extraction(selector)
    @html.css(selector).map do |tag|
      attribute           = tag.name == 'link' ? 'href' : 'src'
      url                 = get_url(tag[attribute])
      filename, extension = filename_extension(url)
      folder              = subfolder(extension)
      target              = join_paths('demo', folder, filename)

      { filename: filename, folder: folder, tag: tag, target: target, url: url }
    end
  end

  def filename_extension(url)
    path       = URI.parse(url).path
    extension  = File.extname(path)
    basename   = File.basename(path)
    name, hash = basename.split('-')

    pure_name = "#{name.sub('.debug', '')}#{extension}" if hash

    [pure_name, extension]
  end

  def join_paths(*paths)
    Rails.root.join('public', @media.slug, paths.join('/'))
  end

  def process
    files_for_extraction('link[href*="labs"] , script[src*="labs"]').each do |data|
      filename = data[:filename]
      content  = Rails.application.assets[filename].source
      content  = rename_font(content) if filename == 'labs.css'

      write_file(data[:target], content)
    end

    extract_html
  end

  def rename_css(text)
    text.sub(%r(/assets/labs.+\.css), 'stylesheets/labs.css')
  end

  def remove_elements!
    @html.at_css('.media__edit').remove
  end

  def rename_favicon(text)
    text.sub(%r(/assets/favicon-.+\.ico), 'favicon.ico')
  end

  def rename_font(text)
    text
      .gsub(%r(/assets/blogy-.+\.eot), '../fonts/blogy.eot')
      .gsub(%r(/assets/blogy-.+\.svg), '../fonts/blogy.svg')
      .gsub(%r(/assets/blogy-.+\.ttf), '../fonts/blogy.ttf')
      .gsub(%r(/assets/blogy-.+\.woff), '../fonts/blogy.woff')
  end

  def rename_image(text)
    text.gsub(%r(raty/lib/images), 'images')
  end

  def rename_jquery(text)
    text
      .sub(%r(raty/node_modules/jquery/dist/jquery(\.min)?\.js), '../node_modules/jquery/dist/jquery.min.js')
      .sub(%r(https://.+/dist/jquery(\.min)?\.js), '../node_modules/jquery/dist/jquery.min.js')
  end

  def rename_js(text)
    text.sub(%r(/assets/labs.+\.js), 'javascripts/labs.js')
  end

  def rename_plugin(text)
    text.gsub(%r(#{@media.slug}/(lib/.+)\.(css|js)), '../\1.\2')
  end

  private

  def get_url(url)
    AssetUrl.new(@host, url).to_s
  end

  def subfolder(extension)
    {
      '.css'  => 'stylesheets',
      '.jpeg' => 'images',
      '.jpg'  => 'images',
      '.js'   => 'javascripts',
      '.png'  => 'images',
      '.svg'  => 'images',
    }[extension]
  end

  def write_file(target, content)
    FileUtils.mkdir_p(target.dirname)

    File.open(target, 'wb') { |f| f << content }
  end
end
