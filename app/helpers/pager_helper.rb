module PagerHelper

  attr_reader :pager

  def paginate(model)
    collection = block_given? ? yield(model) : model.all

    @pager = Pager.new collection: collection, params: params, fullpath: request.fullpath

    paged = pager.paginate
    paged = paged[0...-1] if pager.has_next?

    navigator = content_tag :ul, back_button + page_button + next_button, class: 'pager'

    { items: paged, navigator: navigator }
  end

  private

  def back_button
    text = t('pager.previous')
    pager.has_back? ? button(text, 'previous-page', pager.back_url) : button(text, 'previous-page disabled')
  end

  def page_button
    li span(t('pager.page', page: pager.page)), 'page'
  end

  def next_button
    text = t('pager.next')
    pager.has_next? ? button(text, 'next-page', pager.next_url) : button(text, 'next-page disabled')
  end

  def button(text, clazz, url = nil)
    element = url ? link_to(text, url, title: text) : span(text)
    li element, clazz
  end

  def li(element, clazz)
    content_tag :li, element, class: clazz
  end

  def span(text)
    content_tag :span, text, title: text
  end
end
