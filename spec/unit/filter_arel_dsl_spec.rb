require 'spec_helper'

describe FilterMe::Filter::ArelDSL do
	it "creates a new arel field filter method named after the field" do
		model = double("model")
		filter_class = double("filter_class")
		filter_class.stub(:_model).and_return(model)
		filter_class.should_receive(:define_method) do |name, &block|
			name.should eq(:test)
			block.should_not be_nil
		end

		dsl = FilterMe::Filter::ArelDSL.new(filter_class)
		dsl.field(:test, [:gt, :lt, :eq])
	end

	context "after defining a field filter the dynamically created filter method" do
		it "initializes a ArelFieldFilter instance with the values to filter and the filter field configuration" do
			filters = [:test1, :test2]
			relation_mock = double("relation")
			model_mock = double("model")

			FilterMe::Filter::FieldValidator.send(:define_method, "==") do |obj|
				obj.whitelisted_filters == self.whitelisted_filters
			end

			field_filter_instance = double("field filter instance")
			allow(field_filter_instance).to receive(:filter).once

			field_filter_class = double("field filter class")
			allow(field_filter_class).to receive(:new) do |filters, configuration|
				expect(filters).to eq(filters)
				expect(configuration).to eq({
					:field => :test,
					:validator => FilterMe::Filter::FieldValidator.new([:gt, :lt, :eq]),
					:model_class => model_mock
				})

				field_filter_instance
			end

			stub_const("FilterMe::Filter::ArelFieldFilter", field_filter_class)

			# We just need an object that supports and implements #define_method so the 
			# dynamic filter method can be created.
			filter_class = Class.new do
			end

			allow(filter_class).to receive(:_model) { model_mock }

			dsl = FilterMe::Filter::ArelDSL.new(filter_class)
			dsl.field(:test, [:gt, :lt, :eq])

			filter_instance = filter_class.new
			filter_instance.test(relation_mock, filters)
		end

		it "calls filter on the initialized ArelFieldFilter instance with the relation" do
			relation_mock = double("relation")
			model_mock = double("model")

			field_filter_instance = double("field filter instance")
			expect(field_filter_instance).to receive(:filter) { |relation| relation }

			field_filter_class = double("field filter class")
			allow(field_filter_class).to receive(:new) { |filters, configuration| field_filter_instance }

			stub_const("FilterMe::Filter::ArelFieldFilter", field_filter_class)

			# We just need an object that supports and implements #define_method so the 
			# dynamic filter method can be created.
			filter_class = Class.new do
			end

			allow(filter_class).to receive(:_model) { model_mock }

			dsl = FilterMe::Filter::ArelDSL.new(filter_class)
			dsl.field(:test, [:gt, :lt, :eq])

			filter_instance = filter_class.new
			expect(filter_instance.test(relation_mock, [:test1, :test2])).to eq(relation_mock)
		end
	end


	it "creates a new arel relation filter method named after the association" do
		model = double("model")
		filter_class = double("filter_class")
		filter_class.stub(:_model).and_return(model)
		filter_class.stub(:_associations).and_return({})
		filter_class.should_receive(:define_method) do |name, &block|
			name.should eq(:some_models)
			block.should_not be_nil
		end

		dsl = FilterMe::Filter::ArelDSL.new(filter_class)
		dsl.association(:some_models, {:filter_class => filter_class})
	end

	context "after defining an association filter the dynamically created filter method" do
		it "initializes the association filter instance with the values to filter and the filter configuration" do
			filters = [:test1, :test2]
			relation_mock = double("relation")
			allow(relation_mock).to receive(:joins) { relation_mock }
			allow(relation_mock).to receive(:where) { relation_mock }

			model = double("model")
			allow(model).to receive(:name) { "Model" }

			mock_association_filter = double("association filter")
			allow(mock_association_filter).to receive(:filter) { relation_mock }

			mock_association_filter_class = double("assocation filter class")
			mock_association_filter_class.stub(:new).and_return(mock_association_filter)

			expect(mock_association_filter_class).to receive(:new) do |filters, configuration| 
				expect(filters).to eq(filters)
				expect(configuration).to eq({})
				mock_association_filter 
			end

			allow(mock_association_filter_class).to receive(:define_method) do |name, &block|
				allow(mock_association_filter).to receive(name, &block)
			end

			mock_association_filter_class.stub(:_model).and_return(model)

			# We just need an object that supports and implements #define_method so the 
			# dynamic filter method can be created.
			filter_class = Class.new do
			end

			allow(filter_class).to receive(:_model) { model }
			allow(filter_class).to receive(:_associations) { {} }

			dsl = FilterMe::Filter::ArelDSL.new(filter_class)
			dsl.association(:test, {:filter_class => mock_association_filter_class})

			filter_instance = filter_class.new
			filter_instance.test(relation_mock, filters)
		end

		it "calls filter on the association filter instance with the relation" do
			filters = [:test1, :test2]
			relation_mock = double("relation")
			allow(relation_mock).to receive(:joins) { relation_mock }
			allow(relation_mock).to receive(:where) { relation_mock }

			model = double("model")
			allow(model).to receive(:name) { "Model" }

			mock_association_filter = double("association filter")
			expect(mock_association_filter).to receive(:filter) do |relation|
				expect(relation).to eq(relation_mock)

				relation
			end
			mock_association_filter_class = double("assocation filter class")

			mock_association_filter_class.stub(:new).and_return(mock_association_filter)

			mock_association_filter_class.stub(:_model).and_return(model)
			allow(mock_association_filter_class).to receive(:define_method) do |name, &block|
				allow(mock_association_filter).to receive(name, &block)
			end

			# We just need an object that supports and implements #define_method so the 
			# dynamic filter method can be created.
			filter_class = Class.new do
			end

			allow(filter_class).to receive(:_model) { model }
			allow(filter_class).to receive(:_associations) { {} }

			dsl = FilterMe::Filter::ArelDSL.new(filter_class)
			dsl.association(:test, {:filter_class => mock_association_filter_class})

			filter_instance = filter_class.new
			filter_instance.test(relation_mock, filters)
		end
	end
end