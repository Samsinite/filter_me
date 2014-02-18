module FilterMe
	class Filter
		class AllValidator
			def valid_filters?(filters)
				true
			end

			def invalid_filters(filters)
				[]
			end

			def whitelisted_filters
				:all
			end
		end
		class FieldValidator
			attr_reader :whitelisted_filters

			def initialize(whitelisted_filters)
				@whitelisted_filters = whitelisted_filters
			end

			def valid_filters?(filters)
				filters.all? { |filter| whitelisted_filters.include?(filter[0]) || whitelisted_filters.include?(filter[0].to_sym) }
			end

			def invalid_filters(filters)
				filters.select { |filter| !(whitelisted_filters.include? filter[0]) }
			end
		end
	end
end
