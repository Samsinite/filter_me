class UsersFilter < FilterMe::ActiveRecordFilter
	model User

	association :account, :filter_class => AccountsFilter
	field :email, :all
	field :username, :matches
end
