module FilterMe
	class Filter
		class ArelFieldFilter
			attr_accessor :filters, :configuration

			def initialize(filters, configuration)
				@filter_values = filter_values
				@configuration = configuration
			end

			def filter(relation)
				if validator.valid_fields?(filters)
					relation.where(arel_filters.inject { |arel_relation, filter| filter.and(arel_relation) })
				else
					raise FieldsNotWhiteListedError, "The filter fields #{validator.invalid_fields} are not allowed."
			end

			private

			def arel_filters
				self.filters.map { |filter_array| build_filters_from_filter_array(filter_array) }.flatten
			end

			def build_filters_from_filter_array(filter_array)
				type = filter_array[0]
				filter_array[1..-1].map { |value| build_arel_filter(type, value) }
			end

			def build_arel_filter(type, value)
				arel_filter = arel_table[field].send(type, value)
			end

			def arel_table
				configuration[:model_class].arel_table
			end

			def validator
				configuration[:validator]
			end

			def field
				configuration[:field]
			end
		end
	end
end