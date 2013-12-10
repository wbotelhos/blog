guard :rspec, all_on_start: false, all_after_pass: false do
  watch(%r(^app/helpers/application_helper.rb)) { |m| "spec/helpers/application_helper_spec.rb" }
  watch(%r(^app/helpers/article_helper.rb))     { |m| "spec/helpers/article_helper_spec.rb" }
  watch(%r(^app/helpers/social_helper.rb))      { |m| "spec/helpers/social_helper_spec.rb" }
  watch(%r(^app/models/(.+)\.rb$))              { |m| "spec/features/#{m[1]}" }
  watch(%r(^app/models/(.+)\.rb$))              { |m| "spec/models/#{m[1]}" }
  watch(%r(^config/initializers/(.+).rb))       { |m| "spec/initializers/#{m[1]}_spec.rb" }
  watch(%r(^spec/.+_spec\.rb$))
  watch('spec/spec_helper.rb')                  { 'spec' }
end

guard :spork, wait: 120, test_unit: false, cucumber: false, rspec_env: { RAILS_ENV: :test } do
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')
end
