class Paginaty
  LIMIT = 10

  def self.filter(options = {})
    params = options[:params]
    page = params[:page].to_i
    page = 1 unless page > 0

    offset = (page - 1) * LIMIT

    elements = options[:entity].offset(offset).limit(LIMIT + 1)
    elements = elements.published

    has_back = page > 1
    has_next = elements.size > LIMIT

    elements = elements[0, elements.size - 1] if has_next

    url = "#{options[:request].fullpath.split('?')[0]}?page=";

    back_url = url + (page - 1).to_s
    next_url = url + (page + 1).to_s

    back_label = I18n.t("paginaty.previous")
    next_label = I18n.t("paginaty.next")
    page_label = I18n.t("paginaty.page", :page => page)

    paginaty =  %[<ul class="paginaty">]

    if has_back
      paginaty << %[<li class="next-page"><a href="#{back_url}" title="#{back_label}">#{back_label}</a></li>]
    else
      paginaty << %[<li class="next-page disabled"><span title="#{back_label}">#{back_label}</a></li>]
    end

    paginaty << %[<li class="page"><span>#{page_label}</span></li>]

    if has_next
      paginaty << %[<li class="back-page"><a href="#{next_url}" title="#{next_label}">#{next_label}</a></li>]
    else
      paginaty << %[<li class="back-page disabled"><span title="#{next_label}">#{next_label}</span></li>]
    end

    paginaty << %[</ul>]

    { :elements => elements, :pager => paginaty.html_safe }
  end

end
