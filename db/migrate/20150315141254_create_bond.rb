class CreateBond < ActiveRecord::Migration
  def change
		create_table :bonds do |t|
			t.integer :follower_id
			t.integer :leader_id

			t.timestamps null: false
		end
	end
end
