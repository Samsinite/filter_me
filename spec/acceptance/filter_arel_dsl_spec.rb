require 'spec_helper'

class TestModel; end
class TestFilter
	def self._model
		TestModel
	end
end

describe FilterMe::Filter::ArelDSL do
	it "creates a new arel field filter method named after the field" do
		filter_class = double("filter_class")
		filter_class.stub(:_model).and_return(TestModel)
		filter_class.should_receive(:define_method) do |name, &block|
			name.should eq(:test)
			block.should_not be_nil
		end

		dsl = FilterMe::Filter::ArelDSL.new(filter_class)
		dsl.field(:test, [:gt, :lt, :eq])
	end

	context "after defining a field filter the dynamically created arel field filter method" do
		it "initializes a ArelFieldFilter instance with the values to filter and the filter field configuration" do
			relation_mock = double("relation")

			FilterMe::Filter::FieldValidator.send(:define_method, "==") do |obj|
				obj.whitelisted_fields == self.whitelisted_fields
			end

			mock_arel_field_filter_class = Class.new do
				def initialize(filters, configuration)
					expected_filters = [:test1, :test2]
					raise "filters #{filters} is not equal to the expected value #{expected_filters}}" unless expected_filters == filters

					expected_configuration = {:field => :test, :validator => FilterMe::Filter::FieldValidator.new([:gt, :lt, :eq])}
					raise "configuration #{configuration} is not equal to the expected value #{expected_configuration}" unless expected_configuration == configuration
				end

				def filter(relation); end
			end

			stub_const("FilterMe::Filter::ArelFieldFilter", mock_arel_field_filter_class)

			# We just need an object that supports and implements #define_method so the 
			# dynamic field filter method can be created.
			filter_class = Class.new do
			end

			dsl = FilterMe::Filter::ArelDSL.new(filter_class)
			dsl.field(:test, [:gt, :lt, :eq])

			filter_instance = filter_class.new
			filter_instance.test(relation_mock, [:test1, :test2])
		end

		it "calls filter on the initialized ArelFieldFilter instance with the values to filter and the filter field configuration" do
			relation_mock = double("relation")

			mock_arel_field_filter_class = Class.new do
				def initialize(filters, configuration)
				end

				def filter(relation)
					relation
				end
			end

			stub_const("FilterMe::Filter::ArelFieldFilter", mock_arel_field_filter_class)

			# We just need an object that supports and implements #define_method so the 
			# dynamic field filter method can be created.
			filter_class = Class.new do
			end

			dsl = FilterMe::Filter::ArelDSL.new(filter_class)
			dsl.field(:test, [:gt, :lt, :eq])

			filter_instance = filter_class.new
			expect(filter_instance.test(relation_mock, [:test1, :test2])).to eq(relation_mock)
		end
	end

	
	it "creates a new arel relation filter method named after the association" do
		filter_class = double("filter_class")
		filter_class.stub(:_model).and_return(TestModel)
		filter_class.stub(:_assocations).and_return({})
		filter_class.should_receive(:define_method) do |name, &block|
			name.should eq(:some_models)
			block.should_not be_nil
		end

		dsl = FilterMe::Filter::ArelDSL.new(filter_class)
		dsl.association(:some_models, {:filter_class => filter_class})
	end
end