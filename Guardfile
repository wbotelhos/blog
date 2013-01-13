guard :rspec, all_on_start: false, all_after_pass: false do
  watch(%r(^spec/.+_spec\.rb$))
  watch(%r(^app/models/(.+)\.rb$))        { |m| "spec/models/#{m[1]}" }
  watch(%r(^app/models/(.+)\.rb$))        { |m| "spec/features/#{m[1]}" }
  watch(%r(^config/initializers/(.+).rb)) { |m| "spec/initializers/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')            { 'spec' }
end
