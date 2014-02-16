module Fixtures
	module Accounts
		def load_accounts
			Account.create! do |account|
				account.cost = 10000 #100.00 in cents
			end

			Account.create! do |account|
				account.cost = 50000 #100.00 in cents
			end

			Account.create! do |account|
				account.cost = 100000 #100.00 in cents
			end
		end
	end
end
