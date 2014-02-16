class AccountsFilter < FilterMe::ActiveRecordFilter
	model Account

	field :cost, [:lt, :lteq, :gt, :gteq, :eq]
end
