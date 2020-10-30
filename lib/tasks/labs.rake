# frozen_string_literal: true

namespace :labs do
  desc 'Dumps all labs slugs'
  task dump: [:environment] do
    slugs = Lab.published.map(&:slug).join("\n")

    File.open('script/labs/slugs.txt', 'w') do |file|
      file.write("#{slugs}\n")
    end
  end
end
