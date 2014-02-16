require "forwardable"

require 'filter_me/filterable'
require 'filter_me/filter/field_validator'
require 'filter_me/filter/arel_field_filter'
require 'filter_me/filter/dsl'

module FilterMe
	class ActiveRecordFilter
		include Filterable

		class << self
			def inherited(subclass)
				subclass._associations = (_associations || {}).dup
			end

			def filter_for(relation)
				"#{relation.klass.name.pluralize}Filter".constantize
			end

			attr_accessor :_associations, :_model

			extend Forwardable

			def_delegators :dsl, :field, :association, :model

			private

			def dsl
				@dsl ||= Filter::ArelDSL.new(self)
			end
		end

		attr_accessor :configuration, :filters

		# Filters are expected to be an array of arrays where the first value is 
		# the filter type and the remaining values are the values to filter by. Or if the 
		# filter type is a relation, the rest are sub filters (sub-array).
		#
		### Ex:
		# class AccountsFilter < FilterMe::ActiveRecordFilter
		#   model Account
		#
		#   field :type, [:matches, :eq, :not_eq]
		# end
		# class UsersFilter < FilterMe::ActiveRecordFilter
		#   model User
		#
		#   association :account, :filter_class => AccountsFilter
		#   field :username, [:matches, :eq, :not_eq]
		# end
		#
		# then the 'filters' param for an initialization of a user filter which would then
		# filter users by accounts of types that match '%paid%' would look like:
		# [
		#   # filters on the associaton account
		#   [:account, [
		#     [:type, [
		#       [:matches, ["%paid%"]]
		#     ]]
		#   ]],
		#   # filters on field username
		#   [:username, [
		#     [:not_eq, ["user1", "user2"]],
		#     [:matches, ["%user_%"]]
		#   ]]
		# ]
		def initialize(filters, configuration)
			@filters = filters
			@configuration = configuration
		end
	end
end