require 'rubygems'
require 'bundler/setup'
require 'combustion'

Bundler.require :default, :development

# Add rails modules here to have combustion load:
Combustion.initialize! :active_record

require 'rspec/rails'

RSpec.configure do |config|
	config.use_transactional_fixtures = true

	config.include Fixtures::Users
	config.include Fixtures::Accounts
end
