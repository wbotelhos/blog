namespace :labs do
  desc 'Dump all labs slugs'
  task dump: [:environment] do
    labs  = Lab.published.by_published.map &:slug
    files = "LABS=(#{labs.join ' '})"

    File.open('script/labs/config.sh', 'w') { |f| f.write files }
  end
end
