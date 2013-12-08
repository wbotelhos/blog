# coding: utf-8

module CommentHelper
  def anchor(comment)#
    "##{id_for comment}"
  end

  def comment_name(comment, options = {})#
    if comment.url.present?
      url = comment.url

      options.merge! target: :_blank
    else
      url = 'javascript:void(0);'
    end

    link_to comment.name, url, options
  end

  def id_for(comment)#
    "comment-#{comment.id}"
  end

  def self_anchor(comment)#
    link_to "##{comment.id}", anchor(comment), title: t('comment.shortcut'), class: :anchor
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
end
