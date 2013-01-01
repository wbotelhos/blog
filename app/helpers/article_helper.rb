module ArticleHelper
  def article_slug(article, anchor = nil)
    article_path(article.year, article.month, article.day, article.slug, anchor: anchor)
  end

  def article_slug_url(article, anchor = nil)
    article_url(article.year, article.month, article.day, article.slug, anchor: anchor)
  end

  def article_menu(article)
    menus = ''

    link = link_to t('article.permalink'), article_slug(article), title: t('article.permalink')
    menus << menu('link', link, 'permalink')

    link = link_to t('article.comments_count_html', count: article.comments_count), article_slug(article, 'comments'), title: t('comment.other')
    menus << menu('comments-alt', link, class: 'comments')

    link = link_to t('article.published_at', time: l(article.published_at)), 'javascript:void(0);', title: t('article.published_date')
    menus << menu('calendar', link, class: 'published')

    link = link_to t('article.share'), article_slug(article, 'share'), title: t('article.share')
    menus << menu('share', link, class: 'share')

    if is_logged?
      link_edit = link_to t('navigation.article.edit'), articles_edit_path(article), title: t('article.edit')
      menus << menu('edit', link_edit, class: 'edit')
    end

    content_tag :ul, menus.html_safe, class: 'links'
  end

  private

  def menu(icon, link, clazz)
    icon = content_tag :i, nil, class: "icon-#{icon} icon-large"
    content_tag :li, icon + link, class: clazz
  end
end
