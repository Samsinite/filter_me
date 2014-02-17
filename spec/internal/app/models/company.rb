class Company < ActiveRecord::Base
	belongs_to :owner, :class_name => User
	has_many :jobs, :inverse_of => :company
end