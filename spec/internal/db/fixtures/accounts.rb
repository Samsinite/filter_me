module Fixtures
	module Accounts
		def load_accounts
			Account.create! do |account|
				account.cost = 10000
			end

			Account.create! do |account|
				account.cost = 50000
			end

			Account.create! do |account|
				account.cost = 100000
			end
		end
	end
end
