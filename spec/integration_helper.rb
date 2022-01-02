# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] = 'test'
# Prevent database truncation if the environment is production
# abort('The Rails environment is running in production mode!') if Rails.env.production?
# require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'capybara/rspec'
require "capybara-screenshot/rspec"
require "selenium-webdriver"

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
# begin
#   ActiveRecord::Migration.maintain_test_schema!
# rescue ActiveRecord::PendingMigrationError => e
#   puts e.to_s.strip
#   exit 1
# end
RSpec.configure do |config|
  # config.include FactoryBot::Syntax::Methods
  # config.before(:suite) do
    # FactoryBot.find_definitions
  # end

  # config.before(:each, type: :request) do
    # host! '127.0.0.1'
  # end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = true

  # You can uncomment this line to turn off ActiveRecord support entirely.
  # config.use_active_record = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  # config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  # config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before :each, :js do
    Capybara.current_driver = :chrome
  end
end

# RSpec::Sidekiq.configure do |config|
#   # Clears all job queues before each example
#   config.clear_all_enqueued_jobs = true # default => true

#   # Whether to use terminal colours when outputting messages
#   config.enable_terminal_colours = true # default => true

#   # Warn when jobs are not enqueued to Redis but to a job array
#   config.warn_when_jobs_not_processed_by_sidekiq = false # default => true
# end

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
 options.add_argument('--headless')
 #options.add_argument('--disable-dev-shm-usage')
 options.add_argument('--start-maximized')
  options.add_argument('--no-sandbox')
  options.add_argument('--allow-insecure-localhost')
  options.add_argument('--ignore-certificate-errors')
  #options.add_argument('--privileged')
  options.add_argument('--shm-size="2g"')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    capabilities: [options],
    # options: ['--whitelisted-ips=""'],
    url: "http://#{ENV['SELENIUM_HOST']}:#{ENV['SELENIUM_PORT']}/wd/hub",
  )
end

Capybara::Screenshot.register_driver(:chrome) do |driver, path|
  driver.browser.save_screenshot path
end
Capybara::Screenshot.prune_strategy = :keep_last_run
Capybara.server = :webrick
  
Capybara.default_driver = :chrome