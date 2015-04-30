class CreateComment < ActiveRecord::Migration
	def change
		create_table :comments do |t| 
			t.integer :user_id
			t.integer :tweet_id
			t.text 	  :text
			t.date	  :date

			t.timestamps null: false
		end
	end
end
