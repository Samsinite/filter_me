class CompaniesFilter < FilterMe::ActiveRecordFilter
	model Company

	association :jobs, :filter_class => JobsFilter
end