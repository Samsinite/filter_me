module Fixtures
	module Users
		def load_users
			User.create! do |user|
				user.username = "test1"
				user.email = "test2@test.com"

				user.create_account!(:cost => 100000)
			end

			User.create! do |user|
				user.username = "test2"
				user.email = "test2@test.com"

				user.create_account!(:cost => 50000)
			end

			User.create! do |user|
				user.username = "test3"
				user.email = "test3@spaz.com"

				user.create_account!(:cost => 10000)
			end
		end
	end
end
