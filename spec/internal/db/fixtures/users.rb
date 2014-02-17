module Fixtures
	module Users
		def load_users
			User.create! do |user|
				user.username = "test1"
				user.email = "test2@test.com"

				user.create_account!(:cost => 100000)
			end

			user = User.create! do |user|
				user.username = "test2"
				user.email = "test2@test.com"

				user.create_account!(:cost => 50000)
			end
			business = user.businesses.create! do |business|
				business.name = "Test"
			end
			business.jobs.create!(:name => "find_me")

			user = User.create! do |user|
				user.username = "test3"
				user.email = "test3@spaz.com"

				user.create_account!(:cost => 10000)
			end
			business = user.businesses.create! do |business|
				business.name = "Test2"
			end
			business.jobs.create!(:name => "dont_find_me")
		end
	end
end
