class CreateComputers < ActiveRecord::Migration[5.2]
  def change
  	create_table :pcs do |t|
  		t.integer :trainer_id
  		t.integer :pokeball_id
  	end
  end
end
