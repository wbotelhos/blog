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
    html <<         %(<div>#{I18n.t('comment.reply_to')} #{link_to "##{comment.comment.id}", "#{request.fullpath}#comment-#{comment.comment.id}", { title: "#{I18n.t('comment.shortcut_to_this_comment')}" }}</div>) unless comment.comment.nil?
    html <<       '</div>'

    html <<       %(<span>#{t('comment.created_at', time: time_ago_in_words(comment.created_at))}</span>)
    html <<     '</div>'

    html <<     link("#{request.fullpath}#comment-form", I18n.t('comment.reply'), '_self', 'reply-link')

    html <<     content_tag(:div, markdown(comment.body), class: 'text')

    html <<     %(<form action="#{comments_update_path(article, comment, anchor: anchor )}" method="post" onsubmit="return l00s3r('bot-#{comment.id}');" style="display: none;">)
    html <<       input('hidden', '_method', 'put')
    html <<       input('hidden', 'utf8', '✓')
    html <<       input('hidden', 'authenticity_token', form_authenticity_token.to_s)

    html <<       pe(
                    input('text', 'comment[name]', comment.name) +
                    input('text', 'comment[email]', comment.email) +
                    input('text', 'comment[url]', comment.url)
                  )

    html <<       pe(%(<textarea name="comment[body]" rows="20" cols="30">#{comment.body}</textarea>))

    html <<       pe(link('javascript:void(0);', I18n.t('comment.close'), '', 'close'))

    html <<       %(<p class="human"><label for="bot-#{comment.id}">b0t?</label><input id="bot-#{comment.id}" type="checkbox" checked="checked"></p>)

    html <<       pe(input('submit', '', I18n.t('comment.update')))
    html <<     '</form>'
    html <<   '</div>'
    html << '</div>'

    if comment.comments.any? && comment.comments.size > 0
      level += 1
      comment.comments.each { |child| render_comment(article, child, level, html) }
    end

    html
  end

  private

  def link(url, text, target = '', clazz = '')
    target = (target.empty? || target == '_self') ? '' : %( target="#{target}")
    clazz = %( class="#{clazz}") unless clazz.empty?

    %(<a href="#{url}" title="#{text}"#{target}#{clazz}>#{text}</a>)
  end

  def input(type, name, value)
    tag :input, type: type, name: name, value: value
  end

  def pe(content)
    content_tag :p, content
  end

  def social_link_for(social, name)
    (!social.nil? && !social.empty?) ? link_to('', social, title: social, target: '_blank', class: name) : ''
  end

  def photo(comment)
    %(<div class="photo">#{gravatar(comment.email, alt: '', title: comment.name)}</div>)
  def anchor(comment)
    "comment-#{comment.id}"
  end

  def url_anchor(comment)
    "#{request.fullpath}##{anchor(comment)}"
  end

  def comment_number(comment)
    link_to "##{comment.id}", url_anchor(comment), title: I18n.t('comment.shortcut_to_this_comment')
  end
end
