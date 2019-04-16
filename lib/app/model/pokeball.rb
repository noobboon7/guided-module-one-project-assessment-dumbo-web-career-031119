class Pokeball < ActiveRecord::Base
belongs_to :trainer
belongs_to :pokemon

	def display_pokemon
		Pokemon.find(pokemon_id)
	end
end
