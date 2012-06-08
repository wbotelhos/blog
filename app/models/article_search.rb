class ArticleSearch

  def self.search(options)
    Article.search(options[:query], {
      :page => options[:page],
      :per_page => Paginaty::LIMIT
    })
  end

end
