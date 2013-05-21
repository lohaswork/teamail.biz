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
    watch('spec/spec_helper.rb')                        { ["spec/spec_helper", "spec"] }
    watch('config/routes.rb')
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})
    watch(%r{^lib/(.+)\.rb$})
    watch(%r{^app/controllers/(.+)_controller\.rb$})
    # watch(%r{^lib/config/.+\.rb$})
end
