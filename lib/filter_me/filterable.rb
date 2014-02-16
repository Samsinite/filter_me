module FilterMe
	module Filterable
		def filter(relation)
			puts relation.inspect
			self.filters.inject(relation) do |relation, filter|
				self.send filter[0], relation, filter[1]
			end
		end
	end
end