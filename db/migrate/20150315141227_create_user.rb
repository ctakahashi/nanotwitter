class CreateUser < ActiveRecord::Migration
  def change
		create_table :users do |t|
			t.string 		:name
			t.string 		:username
			t.string 		:password
			t.string 		:email
			t.string		:pic

			t.timestamps null: false
		end

		add_index :users, :pic
		add_index :users, :username

		add_index :users, :password
		add_index :users, :email
		add_index :users, :name

	end
end
