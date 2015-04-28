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

	end
end
