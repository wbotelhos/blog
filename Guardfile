guard :rspec, all_after_pass: false, all_on_start: false, cmd: 'spring rspec' do
  watch(%r(^app/(.+)\.rb$))                          { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r(^lib/(.+)\.rb$))                          { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r(^spec/(.+)_spec\.rb$))
  watch(%r(^spec/support/(.+)\.rb$))                 { 'spec' }
  watch('app/controllers/application_controller.rb') { 'spec/controllers' }
  watch('config/routes.rb')                          { 'spec/routing' }
  watch('spec/spec_helper.rb')                       { 'spec' }
end
