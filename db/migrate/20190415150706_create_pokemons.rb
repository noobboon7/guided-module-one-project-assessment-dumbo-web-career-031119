class CreatePokemons < ActiveRecord::Migration[5.2]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :type
      t.integer :total
      t.integer :hp
      t.integer :attack
      t.integer :defense
      t.integer :speed
    end
  end
end
