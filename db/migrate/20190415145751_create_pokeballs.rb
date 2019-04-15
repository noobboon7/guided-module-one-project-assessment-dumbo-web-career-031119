class CreatePokeballs < ActiveRecord::Migration[5.2]
  def change
    create_table :pokeballs do |t|
      t.integer :trainer_id
      t.integer :pokemon_id
    end
  end
end
