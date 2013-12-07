# coding: utf-8

module CommentHelper
  def anchor(comment)#
    "comment-#{comment.id}"
  end

  def comment_name(comment, options = {})
    if comment.url.present?
      url = comment.url

      options.merge! target: :_blank
    else
      url = 'javascript:void(0);'
    end

    link_to comment.name, url, options
  end

  def url_anchor(comment)#
    "#{request.fullpath}##{anchor(comment)}"
  end

  # workaround to simulate the form_builder that does not works.
  def errors_for(comment, key)#
    errors = comment.errors.messages[key]

    content_tag(:span, errors[0], class: 'validation-error') if errors.present?
  end

  private

  def response_description(comment)
    return '' if comment.comment.nil?

    link = link_to("##{comment.comment.id}", url_anchor(comment.comment), title: t('comment.go_to_parent'), class: 'parent-anchor')

    content_tag(:p, t('comment.reply_to')) + link
  end

  def fields(comment)
    content_tag(:p,
      input('text',   'comment[name]',  comment.name) +
      input('text',   'comment[email]', comment.email) +
      input('text',   'comment[url]',   comment.url) +
      input('hidden', 'bot',            'yes')
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

  def comment_box(article, comment, level)
    clazz = ['comment']
    clazz << 'authored' if comment.author
    clazz << "level-#{level}" unless level == 0
    clazz = clazz.join(' ')

    content_tag :div, photo(comment) + content(article, comment), id: anchor(comment), class: clazz
  end
end
