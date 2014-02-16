require 'active_support/concern'

require 'filter_me/filter'
require 'filter_me/version'

module FilterMe
	class FiltersNotWhiteListedError < StandardError; end

	extend ActiveSupport::Concern

	class << self
		def normalize_param(param)
			param.inject([]) do |filter, (k, v)|
				case v
				when Hash
					filter.push([k, FilterMe.normalize_param(v)])
				when Array
					filter.push([k, v])
				else
					filter.push([k, [v]])
				end
			end
		end
	end

	included do
		if respond_to?(:helper_method)
			helper_method :filter_me
		end

		if respond_to?(:hide_action)
			hide_action :filter_me
			hide_action :filter_configuration
			hide_action :build_filter
			hide_action :filter_params
		end
	end

	def filter_me(relation, filter_class=nil)
		klass = filter_class || ActiveRecordFilter.filter_for(relation)
		filter = build_filter(klass)

		filter.filter(relation)
	end

	def filter_configuration
		{}
	end

	def build_filter(filter_class)
		filter_class.new(filter_params, filter_configuration)
	end

	# Normalized Filter params Example:
	# [
	#   # filters on the associaton account
	#   [:account, [
	#     [:type, [
	#       [:eq, ["admin"]]
    #     ]]
	#   ]],
	#   # filters on field username
	#   [:username, [
	#     [:not_in_any, ["sam", "samsinite"]],
	#     [:matches, ["sam%"]]
	#   ]],
	#   [:company, [
	#     [:job, [
	#       [:name, [
	#         [:matches, ["%software%"]]
	#       ]]
	#     ]]
	#   ]]
	# ]

	# FilterMe default params example (Seems straight forward for Rails to parse):
	#   {filters: {
	#     username: {matches: "sam%", not_in_any: ["sam", "samsinite"]},
	#     account: {type: {eq: "admin"}},
	#     company: {job: {name: {matches: "%software%"}}}
	#   }}
	#
	# Instead of Django Tastypie's style (original inspiration):
	#   [{username__matches: "%sam%"}, {account__type__eq: "admin"}]
	def filter_params
		FilterMe.normalize_param(params.fetch(:filters, {}))
	end
end
