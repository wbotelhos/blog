# frozen_string_literal: true

%w[
  comments
  labs
  articles
  users
].each do |table|
  next if %w[ar_internal_metadata schema_migrations].include?(table)

  ApplicationRecord.connection.execute "DELETE FROM #{table};"
  ApplicationRecord.connection.execute "ALTER TABLE #{table} AUTO_INCREMENT = 1;"
end
