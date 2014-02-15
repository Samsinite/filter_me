require 'filter_me/filter'
require 'filter_me/version'

module NotifyMe
	class FieldsNotWhiteListedError < StandardError; end

	extend ActiveSupport::Concern

	def filter_me(relation, filter_class=nil)
		klass = filter_class || ActiveRecordFilter.filter_for(relation)
		filter = build_filter(klass)

		filter.filter(relation)
	end

	def build_filter(filter_class)
		filter_class.new(filter_params, {})
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
		params[:filters].inject([]) do |filters, filter_param|
			filters.push(normailize_param(filter_param))
		end
	end

	def normailize_param(param)
		param.inject([]) do |filter, (k, v)|
			filter.push(k)

			case v
			when Hash
				filter.push(normailize_param(v))
			when Range
				filter.push(v)
			else
				filter.push([v])
			end
		end
	end
end
