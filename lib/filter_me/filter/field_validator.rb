module FilterMe
	class Filter
		class AllValidator
			def valid_fields(fields)
				true
			end

			def allowed_fields
				:all
			end
		end
		class FieldValidator
			attr_reader :allowed_fields

			def initialize(allowed_fields)
				@allowed_fields = allowed_fields
			end

			def valid_fields(fields)
				fields.all? { |field| allowed_fields.include? field }
			end
		end
	end
end
