class CreatePartys < ActiveRecord::Migration[5.2]
  def change
  	create_table :parties do |t|
  		t.integer :pokeball_id
  		t.integer :trainer_id 
  	end
  end
end
