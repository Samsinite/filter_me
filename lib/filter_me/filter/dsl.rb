module FilterMe
	class Filter

		###
		# DSL Syntax (early version, highly subject to change):
		#
		# class UserFilter < FilterMe::ArelFilter
		#   model User
		#
		#   association :account
		#   association :company, filter_class: SuperDuperCompanyFilter
		#
		#   field :login, [:matches]
		#   field :created_at, [:gt, :gteq, :lt, :lteq, :eq]
		#   field :email, :all
		#   ...
		# end
		###
		class ArelDSL
			attr_reader :filter_class

			extend Forwardable

			def initialize(filter_class)
				@filter_class = filter_class
			end

			def model(klass)
				@filter_class._model = klass
			end

			def filter_for_name(name)
				"#{name.to_s.pluralize.camelize}Filter".constantize
			end

			def field(name, filter_types)
				field_validator = filter_types == :all ? AllValidator.new : FieldValidator.new(filter_types)
				filter(name, ArelFieldFilter, { :field => name,
				                                :validator => field_validator,
				                                :model_class => self.filter_class._model })
			end

			def association(name, options={})
				association_filter_class  = options.fetch(:filter_class) { filter_for_name(name) }
				configuration = options.fetch(:configuration, {})
				filter_class._associations[name] = association_filter_class

				filter(name, association_filter_class, configuration, filter_class._model)
			end

			private

			def filter(name, klass, configuration, association = nil)
				filter_class.send(:define_method, name) do |relation, filters|
					filter = klass.new(filters, configuration)
					if association
						relation.joins(name.to_sym).merge(filter.filter(relation))
					else
						relation.merge(filter.filter(relation))
					end
				end
			end
		end
	end
end
