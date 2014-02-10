module FilterMe
	class Filter
		class AllValidator
			def valid_fields(fields)
				true
			end

			def whitelisted_fields
				:all
			end
		end
		class FieldValidator
			attr_reader :whitelisted_fields

			def initialize(whitelisted_fields)
				@whitelisted_fields = whitelisted_fields
			end

			def valid_fields?(fields)
				fields.all? { |field| whitelisted_fields.include? field }
			end

			def invalid_fields(fields)
				fields.select { |field| !(whitelisted_fields.include? field) }
			end
		end
	end
end
