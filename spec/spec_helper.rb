# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
ENV["RAILS_SECRET_KEY_BASE"] ||= SecureRandom.hex

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'webmock/rspec'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

ENV["HEROKU_DEPLOY_PRIVATE_KEY"] = "private\nkey\n"

RSpec.configure do |config|
  config.order = "random"
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false

  config.before do
    stub_meta
    Resque.inline = true
  end

  def fixture_data(name)
    File.read(File.join(File.dirname(__FILE__), "fixtures", "#{name}.json"))
  end

  def default_headers(event, remote_ip = "192.30.252.41")
    {
      'ACCEPT'                 => 'application/json' ,
      'CONTENT_TYPE'           => 'application/json',

      'REMOTE_ADDR'            => remote_ip,
      'HTTP_X_FORWARDED_FOR'   => remote_ip,

      'HTTP_X_GITHUB_EVENT'    => event,
      'HTTP_X_GITHUB_DELIVERY' => SecureRandom.uuid
    }
  end
end
