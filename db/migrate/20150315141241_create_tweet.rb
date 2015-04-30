class CreateTweet < ActiveRecord::Migration
	def change
		create_table :tweets do |t| 
			t.integer		:user_id
			t.text			:text
			
			t.timestamps	null: false
		end

		add_index :tweets, :created_at #added 4/21
	end
end
