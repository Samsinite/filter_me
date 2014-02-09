module FilterMe
	module ActionController
		def filter_me(relation, filter_class=nil)
			klass = filter_class || ActiveRecordFilter.filter_for(relation)
			filter = build_filter(klass)

			filter.filter(relation)
		end

		def build_filter(filter_class)
			filter_class.new(filter_params, {})
		end

		# [
		#   # filters on the associaton account
		#   [:account, [
		#     [:type, [
		#       [:matches, ["%paid%"]]
	    #     ]]
		#   ]],
		#   # filters on field username
		#   [:username, [
		#     [:eq, ["user1", "user2"]],
		#     [:matches, ["%company1_%"]]
		#   ]]
		# ]
		# [{username__matches: "%sam%"}, {account__type__eq: "admin"}]
		def filter_params
			params[:filters].inject([]) do |filters, filter_param|
				filter_param.inject([]) do |filter, (k, v)|
					k.split("__")
					#TODO
				end
			end
		end
	end
end
