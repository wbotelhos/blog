class SidebarPresenter

  def admin
    { :partial => "sidebar/admin" }
  end

  def articles
    articles ||= Article.select("id, title").all

    if articles.size > 0
      { :partial => "sidebar/articles", :locals => { :articles => articles } }
    end
  end

  def categories
    categories ||= Category.scoped

    if categories.size > 0
      { :partial => "sidebar/categories", :locals => { :categories => categories } }
    end
  end

  def links
    links ||= Link.scoped

    if links.size > 0
      { :partial => "sidebar/links", :locals => { :links => links } }
    end
  end

end
