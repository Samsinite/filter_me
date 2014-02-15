require 'spec_helper'

class SomeModel; end

describe FilterMe::Filter::ArelDSL do
	it "creates a new arel field filter method named after the field" do
		filter_class = double("filter_class")
		filter_class.stub(:model).and_return(SomeModel)
		filter_class.should_recieve(:define_method) do |name, &block|
			name.should eq(:test)
			block.should exist
		end

		dsl = FilterMe::Filter::ArelDSL.new(filter_class)
		dsl.field(:test, [:gt, :lt, :eq])
	end
end