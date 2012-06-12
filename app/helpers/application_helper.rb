# coding: utf-8

module ApplicationHelper

  def author(user)
    "".html_safe.tap do |html|
      html << gravatar(user.email, { :alt => "", :title => user.name })
      html << (content_tag :div, simple_format(user.bio.html_safe), :class => "biography" if user.bio)
      html << (content_tag :div, author_social(user).html_safe, :class => "social")
    end
  end

  def author_social(user)
    "".tap do |html|
      html << link_to("", user.github, :title => user.github, :target => "_blank", :class => "github") if user.github
      html << link_to("", user.linkedin, :title => user.linkedin, :target => "_blank", :class => "linkedin") if user.linkedin
      html << link_to("", user.twitter, :title => user.twitter, :target => "_blank", :class => "twitter") if user.twitter
      html << link_to("", user.facebook, :title => user.facebook, :target => "_blank", :class => "facebook") if user.facebook
    end    
  end

  def gravatar(email, options = {})
    hash = Digest::MD5.hexdigest(email)

    url = "http://www.gravatar.com/avatar/#{hash}?d=nm"
    url << "&s=#{options[:size]}" unless options[:size].nil?

    image_tag url, options
  end

  def render_comments(article)
    html = ""

    article.comments.each do |comment|
      if comment.comment.nil?
        html << render_comment(article, comment)
      end
    end

    html.html_safe
  end

  def render_comment(article, comment, level = 0, html = "")
    anchor = "comment-#{comment.id}"
    anchor_full = "#{request.fullpath}##{anchor}"

    html <<  %[<div id="#{anchor}" class="comment#{' author' if comment.author}#{' level-' + level.to_s unless level == 0}">]
    html <<   %[<div class="photo">]
    html <<     (gravatar(comment.email, { :alt => "", :title => comment.name }))
    html <<   %[</div>]

    html <<   %[<div class="body">]
    html <<     %[<div class="name-date">]
    html <<       %[<div class="anchors">]
    html <<         (link_to "##{comment.id}", anchor_full, { :title => "#{I18n.t('comment.shortcut_to_this_comment')}" })
    html <<         %[ #{link_to comment.name, comment.url, { :target => "_blank" }}]
    html <<         %[<div>#{I18n.t("comment.reply_to")} #{link_to "##{comment.comment.id}", "#{request.fullpath}#comment-#{comment.comment.id}", { :title => "#{I18n.t('comment.shortcut_to_this_comment')}" }}</div>] unless comment.comment.nil?
    html <<       %[</div>]

    html <<       %[<span>#{t("comment.created_at", :time => time_ago_in_words(comment.created_at))}</span>]
    html <<     %[</div>]

    html <<     (link_to I18n.t("comment.reply"), "#{request.fullpath}#comment-form", { :class => "reply-link", :onclick => "replyComment(#{comment.id}, '#{comment.name}');" })

    html <<     %[<div class="text">#{markdown comment.body}</div>]

    html <<     %[<form action="#{update_comment_path(article, comment, { :anchor => anchor })}" method="post" style="display: none;">]
    html <<       %[<input type="hidden" name="_method" value="put" />]
    html <<       %[<input type="hidden" name="utf8" value="✓">]
    html <<       %[<input type="hidden" name="authenticity_token" value="#{form_authenticity_token.to_s}">]
    
    html <<       %[<p>]
    html <<         %[<input type="text" name="comment[name]" value="#{comment.name}" />]
    html <<         %[<input type="text" name="comment[email]" value="#{comment.email}" />]
    html <<         %[<input type="text" name="comment[url]" value="#{comment.url}" />]
    html <<       %[</p>]

    html <<       %[<p>]
    html <<         %[<textarea name="comment[body]" rows="20" cols="30">#{comment.body}</textarea>]
    html <<       %[</p>]

    html <<       %[<p>]
    html <<         %[<input type="submit" value="#{I18n.t('comment.update')}" />]
    html <<       %[</p>]
    html <<     %[</form>]

    html <<   %[</div>]
    html << %[</div>]

    if !comment.comments.nil? && comment.comments.size > 0
      level += 1

      comment.comments.each do |comment|
        render_comment(article, comment, level, html)
      end
    end

    html
  end
end
