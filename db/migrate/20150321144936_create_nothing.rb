class CreateNothing < ActiveRecord::Migration
  def change
  	create_table :nothings do |t|
  		t.string :blank
  	end

	add_column :users, :pic, :string
  end
end