require 'spec_helper'

describe FilterMe::Filter::ArelFieldFilter do
	context "with only greater than and less than allowed" do
		let(:field) { :test }
		let(:arel_table) do
			Arel::Table.new("model")
		end

		let(:filters) { [:lt, :gt] }

		let(:model_class) do
			model = double("model")
			allow(model).to receive(:arel_table) { arel_table }

			model
		end

		let(:configuration) do
			{
				:field => field,
				:model_class => model_class,
				:validator => FilterMe::Filter::FieldValidator.new(filters)
			}
		end

		it "can create an arel field filter with a less than filter" do
			field_filter = FilterMe::Filter::ArelFieldFilter.new([[:lt, [10]]], configuration)
		end

		it "can create an arel field filter with a greater than filter" do
			field_filter = FilterMe::Filter::ArelFieldFilter.new([[:gt, [10]]], configuration)
		end

		it "can create an arel field filter with a greater than and less than filter" do
			field_filter = FilterMe::Filter::ArelFieldFilter.new([[:gt, [10]], [:lt, [20]]], configuration)
		end

		it "cannot create an arel field filter with a equal filter" do
			expect { FilterMe::Filter::ArelFieldFilter.new([[:eq, [10]]], configuration) }.to raise_error
		end
	end
	context "with all types allowed" do
		let(:field) { :test }
		let(:arel_table) do
			Arel::Table.new("model")
		end

		let(:model_class) do
			model = double("model")
			allow(model).to receive(:arel_table) { arel_table }

			model
		end

		let(:configuration) do
			{
				:field => field,
				:model_class => model_class,
				:validator => FilterMe::Filter::AllValidator.new
			}
		end

		it "can create a arel field filter" do
			field_filter = FilterMe::Filter::ArelFieldFilter.new([[:lt, [10]], [:gt, [1]]], configuration)
		end

		it "builds the correct arel filter with one filter type of one filter value" do
			field_filter = FilterMe::Filter::ArelFieldFilter.new([[:lt, [10]]], configuration)
			relation_mock = double("relation")
			expect(relation_mock).to receive(:where) do |created_filter|
				arel_filter = arel_table[field].lt(10)
				expect(created_filter).to eq(arel_filter)
			end

			field_filter.filter(relation_mock)
		end

		it "builds the correct arel filter with one filter type of two filter values" do
			field_filter = FilterMe::Filter::ArelFieldFilter.new([[:matches, ["%hi%", "%hey%"]]], configuration)
			relation_mock = double("relation")
			expect(relation_mock).to receive(:where) do |created_filter|
				arel_filter = arel_table[field].matches("%hey%").and(arel_table[field].matches("%hi%"))
				expect(created_filter).to eq(arel_filter)
			end

			field_filter.filter(relation_mock)
		end

		it "builds the correct arel filter with two filter types of one filter value each" do
			field_filter = FilterMe::Filter::ArelFieldFilter.new([[:gt, [1]], [:lt, [10]]], configuration)
			relation_mock = double("relation")
			expect(relation_mock).to receive(:where) do |created_filter|
				arel_filter = arel_table[field].lt(10).and(arel_table[field].gt(1))
				expect(created_filter).to eq(arel_filter)
			end

			field_filter.filter(relation_mock)
		end

		it "builds the correct arel filter with two filter types of two filter value each" do
			field_filter = FilterMe::Filter::ArelFieldFilter.new([[:matches, ["%hi%", "%hey%"]], [:lt, ["z", "Z"]]], configuration)
			relation_mock = double("relation")
			expect(relation_mock).to receive(:where) do |created_filter|
				arel_filter = arel_table[field].lt("Z")
				                               .and(arel_table[field].lt("z")
				                               .and(arel_table[field].matches("%hey%")
				                               .and(arel_table[field].matches("%hi%"))))
				expect(created_filter).to eq(arel_filter)
			end

			field_filter.filter(relation_mock)
		end
	end
end