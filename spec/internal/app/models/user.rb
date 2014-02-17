class User < ActiveRecord::Base
	has_one :account
	has_many :businesses, :class_name => Company, :foreign_key => :owner_id, :inverse_of => :owner
	has_many :jobs, :through => :businesses
end
