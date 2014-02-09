module Fixtures
	module Users
		def load_user
			User.create! do |user|
				user.username = "test"
				user.email = "test@test.com"

				user.account.create(:cost => 10000) #100.00 in cents
			end
		end
	end
end
