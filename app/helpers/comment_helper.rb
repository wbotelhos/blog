# coding: utf-8

module CommentHelper
  def render_comments(article)
    html = ''

    article.comments.each do |comment|
      if comment.comment.nil?
        html << render_comment(article, comment)
      end
    end

    html.html_safe
  end

  def render_comment(article, comment, level = 0, html = '')
    anchor = "comment-#{comment.id}"
    anchor_full = "#{request.fullpath}##{anchor}"

    html <<  %(<div id="#{anchor}" class="comment#{' authored' if comment.author}#{' level-' + level.to_s unless level == 0}">)
    html <<   photo(comment)

    html <<   '<div class="content">'
    html <<     '<div class="name-date">'
    html <<       '<div class="anchors">'
    html <<         (link_to "##{comment.id}", anchor_full, { title: "#{I18n.t('comment.shortcut_to_this_comment')}" })
    html <<         link(comment.url, comment.name, '_blank', 'name')
    html <<         %(<div>#{I18n.t('comment.reply_to')} #{link_to "##{comment.comment.id}", "#{request.fullpath}#comment-#{comment.comment.id}", { title: "#{I18n.t('comment.shortcut_to_this_comment')}" }}</div>) unless comment.comment.nil?
    html <<       '</div>'

    html <<       %(<span>#{t('comment.created_at', time: time_ago_in_words(comment.created_at))}</span>)
    html <<     '</div>'

    html <<     link("#{request.fullpath}#comment-form", I18n.t('comment.reply'), '_self', 'reply-link')

    html <<     %(<div class="text">#{markdown comment.body}</div>)

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

      comment.comments.each do |comment|
        render_comment(article, comment, level, html)
      end
    end

    html
  end

  private

  def link(url, label, target = '', clazz = '')
    target = (target.empty? || target == '_self') ? '' : %( target="#{target}")
    clazz = %( class="#{clazz}") unless clazz.empty?

    %(<a href="#{url}" title="#{label}"#{target}#{clazz}>#{label}</a>)
  end

  def input(type, name, value)
    %(<input type="#{type}" name="#{name}" value="#{value}" />)
  end

  def pe(content)
    "<p>#{content}</p>"
  end

  def social_link_for(social, name)
    (!social.nil? && !social.empty?) ? link_to('', social, title: social, target: '_blank', class: name) : ''
  end

  def photo(comment)
    %(<div class="photo">#{gravatar(comment.email, alt: '', title: comment.name)}</div>)
  end
end
