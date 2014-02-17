class UsersFilter < FilterMe::ActiveRecordFilter
	model User

	association :account, :filter_class => AccountsFilter
	association :businesses, :filter_class => CompaniesFilter
	field :email, :all
	field :username, :matches
end
