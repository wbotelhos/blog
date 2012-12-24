# coding: utf-8

module CommentHelper
  def render_comments(article)
    ''.tap do |html|
      article.comments.each do |comment|
        html << render_comment(article, comment) if comment.comment.nil?
      end
    end.html_safe
  end

  def render_comment(article, comment, level = 0, html = '')
    anchor = anchor(comment)

    html <<  %(<div id="#{anchor}" class="comment#{' authored' if comment.author}#{' level-' + level.to_s unless level == 0}">)
    html <<   photo(comment)

    html <<   '<div class="content">'
    html <<     '<div class="name-date">'
    html <<       '<div class="anchors">'
    html <<         comment_number(comment)
    html <<         link(comment.url, comment.name, '_blank', 'name')
    html <<         response_description(comment)

    html <<       '</div>'

    html <<       %(<span>#{t('comment.created_at', time: time_ago_in_words(comment.created_at))}</span>)
    html <<     '</div>'

    html <<     link("#{request.fullpath}#comment-form", I18n.t('comment.reply'), '_self', 'reply-link')

    html <<     content_tag(:div, markdown(comment.body), class: 'text')

    html <<     %(<form action="#{comments_update_path(article, comment, anchor: anchor )}" method="post" onsubmit="return l00s3r('bot-#{comment.id}');" style="display: none;">)
    html <<       hidden_fields
    html <<       fields(comment)

    html <<       pe(link('javascript:void(0);', I18n.t('comment.close'), '', 'close'))

    html <<       %(<p class="human"><label for="bot-#{comment.id}">b0t?</label><input id="bot-#{comment.id}" type="checkbox" checked="checked"></p>)

    html <<       pe(input('submit', '', I18n.t('comment.update')))
    html <<     '</form>'
    html <<   '</div>'
    html << '</div>'

    if comment.comments.any?
      level += 1
      comment.comments.each { |child| render_comment(article, child, level, html) }
    end

    html
  end



  private

  def input(type, name, value)
    tag :input, type: type, name: name, value: value
  end

  def pe(content)
    content_tag :p, content
  end

  def hidden_fields
    pe(
      input('hidden', '_method', 'put') +
      input('hidden', 'utf8', '✓') +
      input('hidden', 'authenticity_token', form_authenticity_token.to_s)
    )
  end

  def fields(comment)
    pe(
      input('text', 'comment[name]',  comment.name) +
      input('text', 'comment[email]', comment.email) +
      input('text', 'comment[url]',   comment.url)
    ) +

    pe(content_tag :textarea, comment.body, name: 'comment[body]', rows: 20, cols: 30)
  end

  def photo(comment)
    content_tag :div, gravatar(comment.email, alt: '', title: comment.name), class: 'photo'
  end

  def anchor(comment)
    "comment-#{comment.id}"
  end

  def url_anchor(comment)
    "#{request.fullpath}##{anchor(comment)}"
  end

  def comment_number(comment)
    link_to "##{comment.id}", url_anchor(comment), title: I18n.t('comment.shortcut_link')
  end

  def response_description(comment)
    return '' if comment.comment.nil?

    link = link_to("##{comment.comment.id}", url_anchor(comment.comment), title: I18n.t('comment.go_to_parent'))

    content_tag :p, "#{I18n.t('comment.reply_to')} #{link}".html_safe
  end


  def link(url, text, target = '', clazz = '')
    target = (target.empty? || target == '_self') ? '' : %( target="#{target}")
    clazz = %( class="#{clazz}") unless clazz.empty?

    %(<a href="#{url}" title="#{text}"#{target}#{clazz}>#{text}</a>)
  end

  def social_link_for(social, name)
    (!social.nil? && !social.empty?) ? link_to('', social, title: social, target: '_blank', class: name) : ''
  end


end
