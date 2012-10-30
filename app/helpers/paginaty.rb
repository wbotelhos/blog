class Paginaty
  LIMIT = 10

  def self.filter(options = {})
    params = options[:params]
    page = params[:page].to_i
    page = 1 unless page > 0

    offset = (page - 1) * LIMIT

    elements = options[:entity].offset(offset).limit(LIMIT + 1).published

    has_back = page > 1
    has_next = elements.size > LIMIT

    elements = elements[0, elements.size - 1] if has_next

    url = "#{options[:request].fullpath.split('?')[0]}?page=";

    back_url = url + (page - 1).to_s
    next_url = url + (page + 1).to_s

    back_label = I18n.t('paginaty.previous')
    next_label = I18n.t('paginaty.next')
    page_label = I18n.t('paginaty.page', page: page)

    paginaty =  '<ul class="paginaty">'
    paginaty <<   (has_back ? li(link(back_url, back_label), 'back-page') : li(span(back_label), 'back-page disabled'))
    paginaty <<   li(span(page_label), 'page')
    paginaty <<   (has_next ? li(link(next_url, next_label), 'next-page') : li(span(next_label), 'next-page disabled'))
    paginaty << '</ul>'

    { elements: elements, pager: paginaty.html_safe }
  end

  private

  def self.li(element, clazz)
    %(<li class="#{clazz}">#{element}</li>)
  end

  def self.link(url, label)
    %(<a href="#{url}" title="#{label}">#{label}</a>)
  end

  def self.span(label)
    %(<span title="#{label}">#{label}</span>)
  end
end
