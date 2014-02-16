require 'spec_helper'

describe AccountsFilter do
	before(:each) do
		load_accounts
	end

	let(:mock_controller_class) do
		controller = Class.new do
			include FilterMe

			attr_accessor :params

			def index 
				filter_me(Account.all)
			end
		end
	end

	let(:mock_controller) do
		mock_controller_class.new
	end

	it "returns all accounts without any filtering" do
		mock_controller.params = {}

		expect(mock_controller.index.length).to eq(3)
	end

	it "returns one account when filtering cost less than 100000 and greater than 10000" do
		mock_controller.params = {:filters => {
			:cost => {:lt => 100000, :gt => 10000}
		}}

		expect(mock_controller.index.length).to eq(1)
	end

	it "returns two accounts when filtering cost less than or equal to 100000 and greater than 10000" do
		mock_controller.params = {:filters => {
			:cost => {:lteq => 100000, :gt => 10000}
		}}

		expect(mock_controller.index.length).to eq(2)
	end

	it "returns two accounts when filtering cost less than 100000 and greater than or equal to 10000" do
		mock_controller.params = {:filters => {
			:cost => {:lt => 100000, :gteq => 10000}
		}}

		expect(mock_controller.index.length).to eq(2)
	end

	it "returns three accounts when filtering cost less than or equal to 100000 and greater than or equal to 10000" do
		mock_controller.params = {:filters => {
			:cost => {:lteq => 100000, :gteq => 10000}
		}}

		expect(mock_controller.index.length).to eq(3)
	end
end