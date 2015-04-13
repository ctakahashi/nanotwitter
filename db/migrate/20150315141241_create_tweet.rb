class CreateTweet < ActiveRecord::Migration
  def change
		create_table :tweets do |t| 
			t.integer		:user_id
			t.boolean		:retweet
			t.integer		:retweet_id
			t.text			:text
			
			t.timestamps	null: false
		end

		add_index :tweets, :user_id
		add_index :tweets, :text
	end
end
