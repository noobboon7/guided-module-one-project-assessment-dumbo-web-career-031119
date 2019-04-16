class Trainer < ActiveRecord::Base
has_many :pokeballs
has_many :pokemons, through: :pokeballs

	def trainer_pokemon
		Pokeball.where(trainer_id: self.id)
	end

	
end
