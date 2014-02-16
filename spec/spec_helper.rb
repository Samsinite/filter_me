require 'rubygems'
require 'bundler/setup'
require 'combustion'

Bundler.require :default, :development

# Add rails modules here to have combustion load:
Combustion.initialize! :active_record

require 'rspec/rails'

# Load fixture helpers for testing
Dir[File.join(File.dirname(__FILE__), 'db', "fixtures" '*.rb')].each { |file| require file }

RSpec.configure do |config|
	config.use_transactional_fixtures = true

	#config.include Fixtures::Users
	#config.include Fixtures::Accounts
end
