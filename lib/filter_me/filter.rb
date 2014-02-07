require "forwardable"

require 'filter_me/filterable'
require 'filter_me/filter/field_validator'
require 'filter_me/filter/arel_field_filter'
require 'filter_me/filter/dsl'

module FilterMe
	class ArelFilter
		include Filterable

		class << self
			def inherited(subclass)
				subclass._associations = (_associations || {}).dup
			end

			attr_accessor :_associations, :_model

			extend Forwardable

			def_delegators :dsl, :filter

			private

			def dsl
				@dsl ||= ArelDSL.new(self)
			end
		end

		attr_accessor :configuration, :filters

		# filters are expected to be an array of arrays where the first value is 
		# the filter type and the remaining values are the values to filter by. Or if the 
		# filter type is a relation, the rest are sub filters (sub-array)
		def initialize(filters, configuration)
			filters = filters
			configuration = configuration
		end
	end
end