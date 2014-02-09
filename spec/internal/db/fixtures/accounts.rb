module Fixtures
	module Accounts
		def load_account
			Account.create! do |account|
				account.cost = 10000 #100.00 in cents
			end
		end
	end
end
