# frozen_string_literal: true

seed = Rails.root.join('db', 'seeds')

require "#{seed}/functions"
require "#{seed}/common"
require "#{seed}/setup"

files = %i[
  users
  articles
  comments
  labs
]

files.each do |items|
  [items].flatten.each do |file|
    require "#{seed}/#{file}"
  rescue LoadError => e
    puts "Could not load file #{file}: #{e.message}"
  end
end
