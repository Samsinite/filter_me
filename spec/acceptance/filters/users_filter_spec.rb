require 'spec_helper'

describe UsersFilter do
	before(:each) do
		load_users
	end

	let(:mock_controller_class) do
		controller = Class.new do
			include FilterMe

			attr_accessor :params

			def index 
				filter_me(User.all)
			end
		end
	end

	let(:mock_controller) do
		mock_controller_class.new
	end

	it "returns all users without any filtering" do
		mock_controller.params = {}

		expect(mock_controller.index.length).to eq(User.all.length)
	end

	it "returns users with e-mails from the domain test.com" do
		mock_controller.params = {:filters => {
			:email => {:matches => "%test.com"}
		}}

		mock_controller.index.each do |user|
			expect(user.email).to end_with "test.com"
		end
	end

	it "returns users with e-mails from the domain test.com with accounts that cost less than 100000" do
		mock_controller.params = {:filters => {
			:email => {:matches => "%test.com"},
			:account => {:cost => {:lt => 100000}}
		}}

		mock_controller.index.each do |user|
			expect(user.email).to end_with "test.com"
			expect(user.account.cost).to be < 100000
		end
	end
end