class JobsFilter < FilterMe::ActiveRecordFilter
	model Job

	field :name, [:matches]
end