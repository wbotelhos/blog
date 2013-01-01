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
    html << comment_box(article, comment, level)

    if comment.comments.any?
      level += 1
      comment.comments.each { |child| render_comment(article, child, level, html) }
    end

    html
  end

  private

  def anchor(comment)
    "comment-#{comment.id}"
  end

  def url_anchor(comment)
    "#{request.fullpath}##{anchor(comment)}"
  end

  def input(type, name, value)
    tag :input, type: type, name: name, value: value
  end

  def photo(comment)
    content_tag :div, gravatar(comment.email, alt: '', title: comment.name), class: 'photo'
  end

  def comment_number(comment)
    link_to "##{comment.id}", url_anchor(comment), title: t('comment.shortcut_link')
  end

  def commenter_name(comment)
    link_to comment.name, comment.url, target: '_blank', class: 'name'
  end

  def response_description(comment)
    return '' if comment.comment.nil?

    link = link_to("##{comment.comment.id}", url_anchor(comment.comment), title: t('comment.go_to_parent'), class: 'parent-anchor')

    content_tag(:p, t('comment.reply_to')) + link
  end

  def date(comment)
    icon = content_tag :i, nil, class: 'icon-time icon-large'
    text = t('comment.created_at', time: time_ago_in_words(comment.created_at))

    content_tag :span, icon + text
  end

  def response_link(comment)
    link_to t('comment.reply'), "#{request.fullpath}#comment-form", target: '_self', class: 'reply-link'
  end

  def anchors(comment)
    content_tag :div, comment_number(comment) + commenter_name(comment) + response_description(comment), class: 'anchors'
  end

  def header(comment)
    content_tag(:div, anchors(comment) + date(comment), class: 'name-date') + response_link(comment)
  end

  def body(comment)
    content_tag :div, markdown(comment.body), class: 'text'
  end

  def fields(comment)
    content_tag(:p,
      input('text', 'comment[name]',  comment.name) +
      input('text', 'comment[email]', comment.email) +
      input('text', 'comment[url]',   comment.url)
    ) +

    content_tag(:p,
      content_tag(:textarea, comment.body, name: 'comment[body]', rows: 20, cols: 30)
    )
  end

  def form_closer(comment)
    content_tag :p, link_to(t('comment.close'), 'javascript:void(0);', class: 'close')
  end

  def anti_bot(comment)
    id = "bot-#{comment.id}"
    content_tag :p, label_tag(id, 'b0t?') + check_box_tag(id, nil, true), class: 'human'
  end

  def submit_button
    content_tag :p, submit_tag(t('comment.update'), name: nil)
  end

  def form(article, comment)
    anchor    = anchor(comment)
    onsubmit  = "return l00s3r('bot-#{comment.id}');"
    style     = 'display: none;'
    url       = comments_update_path(article, comment, anchor: anchor)

    form_tag(url, method: :put, onsubmit: onsubmit, style: style) do
      fields(comment) << form_closer(comment) << anti_bot(comment) << submit_button
    end
  end

  def content(article, comment)
    content_tag :div, header(comment) + body(comment) + form(article, comment), class: 'content'
  end

  def comment_box(article, comment, level)
    clazz = ['comment']
    clazz << 'authored' if comment.author
    clazz << ('level-' + level.to_s) unless level == 0
    clazz = clazz.join(' ')

    content_tag :div, photo(comment) + content(article, comment), id: anchor(comment), class: clazz
  end
end
