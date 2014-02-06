module FilterMe
	class Filter
		class DSL
			attr_reader :filter_class

			def initialize(filter_class)
				@filter_class = filter_class
			end

			def filter(field, *options)
			end
		end
	end
end
