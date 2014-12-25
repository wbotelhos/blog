namespace :labs do
  desc 'Dumps all labs slugs'
  task dump: [:environment] do
    slugs = Lab.published.by_published.map(&:slug).join ''

    File.open('script/labs/slugs.sh', 'w') do |file|
      file.write "SLUGS=(#{slugs})"
    end
  end
end
