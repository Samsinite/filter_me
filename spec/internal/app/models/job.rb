class Job < ActiveRecord::Base
	belongs_to :company, :inverse_of => :jobs
end