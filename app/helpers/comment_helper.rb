module CommentHelper
  def anchor(comment)
    "##{id_for comment}"
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

  def id_for(comment)
    "comment-#{comment.id}"
  end

  def self_anchor(comment)
    link_to "##{comment.id}", anchor(comment), title: t('comment.shortcut'), class: :anchor
  end
end
