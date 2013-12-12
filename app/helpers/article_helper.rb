module ArticleHelper
  def article_slug(article, anchor = nil)
    slug_path(article.slug, anchor: anchor)
  end

  def article_slug_url(article, anchor = nil)
    slug_url(article.slug, anchor: anchor)
  end

  def published_at(article)
    l article.published_at || article.created_at
  end

  def twitter_button(options = {})
    options = {
      text: %("#{options[:text]}" ~ ),
      url:  options[:url],
      via:  'wbotelhos'
    }

    link = link_to 'Tweet', "https://twitter.com/intent/tweet?#{to_query options}", target: :_blank

    content_tag :div, link, class: :twitter
  end

  private

  def to_query(options)
    options.map { |key, value| "#{key}=#{CGI.escape value}" }.join '&'
  end
end
