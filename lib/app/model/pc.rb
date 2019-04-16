class PC < ActiveRecord::Base
belongs_to :trainers
has_many :pokemons, through: :trainers
end
