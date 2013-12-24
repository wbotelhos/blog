xml.instruct!

xml.rss version: '2.0', 'xmlns:dc' => 'http://purl.org/dc/elements/1.1/' do
  xml.channel do
    xml.title CONFIG['author']
    xml.description CONFIG['description']
    xml.language I18n.locale.to_s
    xml.link CONFIG['url_http']

    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.pubDate article.published_at.to_s(:rfc822)
        xml.link media_slug_url article
        xml.guid media_slug_url(article), isPermalink: true
        xml.creator article.user.name

        xml.description do
          xml.cdata! markdown article.body
        end
      end
    end
  end
end
