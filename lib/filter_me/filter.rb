require 'filter_me/filter/dsl'

module FilterMe
	class Filter

		class << self
			attr_accessor :_fields, :_associations

			def applicable_conditions(params={})
			end

			def apply_filter(conditions)

			extend Forwardable

			def_delegators :dsl, :filter

			private

			def dsl
				@dsl ||= DSL.new(self)
			end
		end

		attr_accessor :configuration

		def initialize(configuration)
		end

		def filter(relation)
		end
end