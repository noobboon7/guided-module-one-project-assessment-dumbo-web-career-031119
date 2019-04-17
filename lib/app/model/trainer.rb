class Trainer < ActiveRecord::Base
has_many :pokeballs, dependent: :destroy
has_many :pokemons, through: :pokeballs

	def trainer_pokemon
		Pokeball.where(trainer_id: self.id)
	end


end
