ActiveRecord::Schema.define do
	create_table :users, :force => true do |t|
		t.string :username
		t.string :email
		t.timestamps
	end

	create_table :accounts, :force => true do |t|
		t.integer :user_id
		t.integer :cost
		t.timestamps
	end

	create_table :companies, :force => true do |t|
		t.integer :owner_id
		t.string :name
		t.timestamps
	end

	create_table :jobs, :force => true do |t|
		t.integer :company_id
		t.string :name
		t.timestamps
	end
end