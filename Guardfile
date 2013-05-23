require 'active_support/core_ext'

guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' }, :test_unit => false do
  watch('config/application.rb')
  watch('config/environment.rb')
  watch(%r{^config/environments/.+\.rb$})
  watch(%r{^config/initializers/.+\.rb$})
  watch('Gemfile')
  watch('Gemfile.lock')
  watch('spec/spec_helper.rb')
  watch('spec/requests/')
end

guard 'rspec', :version => 2, :all_after_pass => false, :cli => '--drb' do
    watch('spec/spec_helper.rb')                        { ["spec"] }
    watch(%r{^config/(.+)\.rb$})                        { ["spec"] }
    watch(%r{^spec/.+_spec\.rb$})                       { ["spec"] }
    watch(%r{^app/(.+)\.rb$})                           { ["spec"] }
    watch(%r{^lib/(.+)\.rb$})                           { ["spec"] }
end
