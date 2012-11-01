# coding: utf-8

module ApplicationHelper
  def author(user)
    ''.html_safe.tap do |html|
      html << gravatar(user.email, { alt: '', title: user.name })
      html << (content_tag :div, simple_format(user.bio.html_safe), class: 'biography' if user.bio)
      html << (content_tag :div, author_social(user).html_safe, class: 'social')
    end
  end

  def author_social(user)
    ''.tap do |html|
      html << social_link_for(user.github, 'github')
      html << social_link_for(user.linkedin, 'linkedin')
      html << social_link_for(user.twitter, 'twitter')
      html << social_link_for(user.facebook, 'facebook')
    end
  end

  def gravatar(email, options = {})
    hash = Digest::MD5.hexdigest(email)

    url = "http://www.gravatar.com/avatar/#{hash}?d=mm"
    url << "&s=#{options[:size]}" unless options[:size].nil?

    image_tag url, options
  end

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
    html <<   '<div class="photo">'
    html <<     (gravatar(comment.email, { alt: '', title: comment.name }))
    html <<   '</div>'

    html <<   '<div class="body">'
    html <<     '<div class="name-date">'
    html <<       '<div class="anchors">'
    html <<         (link_to "##{comment.id}", anchor_full, { title: "#{I18n.t('comment.shortcut_to_this_comment')}" })
    html <<         link(comment.url, comment.name, '_blank')
    html <<         %[<div>#{I18n.t('comment.reply_to')} #{link_to "##{comment.comment.id}", "#{request.fullpath}#comment-#{comment.comment.id}", { title: "#{I18n.t('comment.shortcut_to_this_comment')}" }}</div>] unless comment.comment.nil?
    html <<       '</div>'

    html <<       %(<span>#{t('comment.created_at', time: time_ago_in_words(comment.created_at))}</span>)
    html <<     '</div>'

    html <<     link("#{request.fullpath}#comment-form", I18n.t('comment.reply'), '_self', 'reply-link')

    html <<     %(<div class="text">#{markdown comment.body}</div>)

    html <<     %(<form action="#{update_comment_path(article, comment, { anchor: anchor })}" method="post" style="display: none;">)
    html <<       input('hidden', '_method', 'put')
    html <<       input('hidden', 'utf8', '✓')
    html <<       input('hidden', 'authenticity_token', form_authenticity_token.to_s)

    html <<       '<p>'
    html <<         input('text', 'comment[name]', comment.name)
    html <<         input('text', 'comment[email]', comment.email)
    html <<         input('text', 'comment[url]', comment.url)
    html <<       '</p>'

    html <<       pe(%(<textarea name="comment[body]" rows="20" cols="30">#{comment.body}</textarea>))

    html <<       pe(link('javascript:void(0);', I18n.t('comment.close'), 'close'))

    html <<       pe(input('submit', '', I18n.t('comment.update')))
    html <<     '</form>'
    html <<   '</div>'
    html << '</div>'

    if !comment.comments.nil? && comment.comments.size > 0
      level += 1

      comment.comments.each do |comment|
        render_comment(article, comment, level, html)
      end
    end

    html
  end

  private

  def link(url, label, target = '_self', clazz = '')
    %(<a href="#{url}" title="#{label}" target="#{target}" class="#{clazz}">#{label}</a>)
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
end
