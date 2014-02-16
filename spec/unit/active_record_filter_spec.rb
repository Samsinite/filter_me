require 'spec_helper'

describe FilterMe::ActiveRecordFilter do
	let(:filters) do
		[
			# filters on associaton account
			[:account, [
				[:type, [
					[:matches, ["%paid%"]]
				]]
			]],
			# filters on field username
			[:username, [
				[:not_eq, ["user1", "user2"]],
				[:matches, ["%user_%"]]
			]]
		]
	end

	it "calls each filter method for every filter it is passed" do
		relation_mock = double("relation")
		model_filter = FilterMe::ActiveRecordFilter.new(filters, {})

		expect(model_filter).to receive(:account).with(relation_mock, filters[0][1]) { relation_mock }
		expect(model_filter).to receive(:username).with(relation_mock, filters[1][1]) { relation_mock }
		model_filter.filter(relation_mock)
	end
end