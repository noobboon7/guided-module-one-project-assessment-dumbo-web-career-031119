class Party < ActiveRecord::Base
belongs_to :trainers
has_many :pokeballs, through: :trainers

	def self.trainer_party(trainer)
		Party.where(trainer_id:trainer.id)
	end
end
