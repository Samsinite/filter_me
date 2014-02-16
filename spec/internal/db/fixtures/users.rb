module Fixtures
	module Users
		def load_users
			User.create! do |user|
				user.username = "test1"
				user.email = "test2@test.com"

				user.account.create(:cost => 100000) #100.00 in cents
			end

			User.create! do |user|
				user.username = "test2"
				user.email = "test2@test.com"

				user.account.create(:cost => 50000) #100.00 in cents
			end

			User.create! do |user|
				user.username = "test3"
				user.email = "test3@spaz.com"

				user.account.create(:cost => 10000) #100.00 in cents
			end
		end
	end
end
