class Pokeball < ActiveRecord::Base
belongs_to :trainers
belongs_to :pokemons
end
