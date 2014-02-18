module FilterMe
	class Filter
		class ArelFieldFilter
			attr_accessor :filters, :configuration

			def initialize(filters, configuration)
				@filters = filters
				@configuration = configuration

				unless validator.valid_filters?(filters)
					raise FiltersNotWhiteListedError, "The filter types #{validator.invalid_filters(filters).map { |filter| filter[0] }} are not allowed."
				end
			end

			def filter(relation)
				model_class.where(arel_filters.inject { |arel_relation, filter| filter.and(arel_relation) })
			end

			private

			def arel_filters
				self.filters.map { |filter_array| build_filters_from_filter_array(filter_array) }.flatten
			end

			def build_filters_from_filter_array(filter_array)
				type = filter_array[0]
				filter_array[1].map { |value| build_arel_filter(type, value) }
			end

			def build_arel_filter(type, value)
				arel_filter = arel_table[field].send(type, value)
			end

			def arel_table
				model_class.arel_table
			end

			def model_class
				configuration[:model_class]
			end

			def validator
				configuration[:validator]
			end

			def field
				configuration[:field].to_sym
			end
		end
	end
end