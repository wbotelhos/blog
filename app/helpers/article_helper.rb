module ArticleHelper
  def article_slug(article, anchor = nil) #
    slug_path(article.slug, anchor: anchor)
  end

  def article_slug_url(article, anchor = nil) #
    slug_url(article.slug, anchor: anchor)
  end

  def published_at(article)
    l article.published_at || article.created_at
  end

  def twitter_button(options = {})#
    options = {
      text: %("#{options[:text]}" ~ ),
      url:  options[:url],
      via:  'wbotelhos'
    }

    link = link_to 'Tweet', "https://twitter.com/intent/tweet?#{to_query options}", target: :_blank

    content_tag :div, link, class: :twitter
  end

  def article_menu(article)
    html = ''
    html << menu('link',         link_to(t('article.permalink'),       article_slug(article),             title: t('article.permalink')))
    html << menu('comments-alt', link_to(comments_label(article),      article_slug(article, 'comments'), title: t('comment.other')))
    html << menu('calendar',     link_to(published_label(article),     'javascript:void(0);',             title: t('article.published_date')))
    html << menu('share',        link_to(t('article.share'),           article_slug(article, 'share'),    title: t('article.share')))
    html << menu('edit',         link_to(t('navigation.article.edit'), articles_edit_path(article),       title: t('article.edit'))) if is_logged?

    content_tag :ul, html.html_safe, class: 'links'
  end

  def tags(article)
    article.categories.map do |category|
      link_to category.name, categories_show_path(category.name.slug), title: category.name
    end.join(' ').html_safe
  end

  private

  def to_query(options)#
    options.map { |key, value| "#{key}=#{CGI.escape value}" }.join '&'
  end

  def comments_label(article)
    t 'comment.count_html', count: article.comments_count
  end

  def published_label(article)
    t 'article.published_at', time: l(article.published_at)
  end

  def menu(icon, link)
    icon = content_tag :i, nil, class: "icon-#{icon} icon-large"
    content_tag :li, icon + link
  end
end
