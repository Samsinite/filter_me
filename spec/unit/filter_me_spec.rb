require 'spec_helper'

describe FilterMe do
	let(:class_with_module) do
		Class.new do
			include FilterMe

			attr_accessor params
		end
	end

	it "should normalize field params correctly" do
		username_field_params = {:matches => "sam%", :not_in_any => ["sam", "samsinite"]}
		username_params_normalized = [
			[:matches, ["sam%"]],
			[:not_in_any, ["sam", "samsinite"]]
		]

		expect(FilterMe.normalize_param(username_field_params)).to eq(username_params_normalized)
	end

	it "should normalize shallow association params correctly" do
		account_association_params = {:type => {:eq => "admin"}}
		account_params_normalized = [[:type, [
			[:eq, ["admin"]]
		]]]

		expect(FilterMe.normalize_param(account_association_params)).to eq(account_params_normalized)
	end

	it "should normalize deeply nested association params correctly" do
		company_association_with_nested_job_association_params = {:job => {:name => {:matches => "%software%"}}}
		company_params_normalized = [[:job, [
			[:name, [
				[:matches, ["%software%"]]
			]]
			]]]

		expect(FilterMe.normalize_param(company_association_with_nested_job_association_params)).to eq(company_params_normalized)
	end
end
