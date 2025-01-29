require 'simplecov'
SimpleCov.start 'rails' do
  add_group 'Services', 'app/services'
  add_group 'Validators', 'app/validators'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'factory_bot_rails'
require 'database_cleaner/active_record'
require 'shoulda/matchers'

require 'action_view'
require 'action_view/template'

SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter if ENV['CI']

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Nastavení RSpec
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Shoulda Matchers konfigurace
  Shoulda::Matchers.configure do |with|
    with.integrate do |config|
      config.test_framework :rspec
      config.library :rails
    end
  end

  # DatabaseCleaner konfigurace
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.filter_rails_from_backtrace!
end