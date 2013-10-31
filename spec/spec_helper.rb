def setup_spec_helper
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  require 'capybara/rspec'
  require 'capybara/rails'
  require 'capybara/poltergeist'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}


  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # including factory_girl syntax in rspec
    config.include FactoryGirl::Syntax::Methods

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    #Make the default JS driver is poltergeist, need not dispale the real
    #browser to support test, if you want to see the real window of test in your
    #own evn, you can run "DIEVER=selenium rspec" or "DIEVER=selenium guard"

    if ENV['DRIVER'] == 'selenium'
      Capybara.javascript_driver = :selenium
    else
      Capybara.javascript_driver = :poltergeist
    end

    #TODO: ignore the js error for now
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, options = { js_errors: false, phantomjs_logger: WarningSuppressor })
    end

    #clean DB after every test case
    config.before :each do
      if Capybara.current_driver == :rack_test
        DatabaseCleaner.strategy = :transaction
      else
        DatabaseCleaner.strategy = :truncation
      end
      DatabaseCleaner.start
    end
    config.after :each do
      DatabaseCleaner.clean
    end
  end

end

require 'spork'

Spork.prefork do
  setup_spec_helper
end

Spork.each_run do
  # This code will be run each time you run your specs.

end

# Following code is used to suppress annoying warnings due to an issue related
#   with Phantomjs and CoreText in Mavericks Runtime Lib.
# These code will be removed when the issue is fixed.
# Thread URL: https://github.com/ariya/phantomjs/issues/11418
module Capybara::Poltergeist
  class Client
    private
    def redirect_stdout
      prev = STDOUT.dup
      prev.autoclose = false
      $stdout = @write_io
      STDOUT.reopen(@write_io)

      prev = STDERR.dup
      prev.autoclose = false
      $stderr = @write_io
      STDERR.reopen(@write_io)
      yield
    ensure
      STDOUT.reopen(prev)
      $stdout = STDOUT
      STDERR.reopen(prev)
      $stderr = STDERR
    end
  end
end

class WarningSuppressor
  class << self
    def write(message)
      if message =~ /QFont::setPixelSize: Pixel size <= 0/ || message =~/CoreText performance note:/ then 0 else puts(message);1;end
    end
  end
end
