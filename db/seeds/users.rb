# frozen_string_literal: true

puts "[seed] #{File.basename(__FILE__)}"

@users = {}

@users[:wbotelhos] = create_user(
  email: 'wbotelhos@example.com',
  name:  'Washington Botleho',
)
