namespace 'app:counter_cache' do
  desc 'Update all counter caches'
  task all: [:environment, :articles, :users]

  desc 'Update articles counter cache'
  task :articles do
    update Article, :comments
  end

  desc 'Update users counter cache'
  task :users do
    update User, :articles
  end

  def update(model, *columns)
    model.find_each do |entity|
      columns.each do |column|
        model.reset_counters(entity.id, column)
      end
    end
  end
end
