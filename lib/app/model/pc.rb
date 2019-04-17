class PC < ActiveRecord::Base
belongs_to :trainers
has_many :pokeballs, through: :trainers
	def self.trainer_pc(trainer)
			PC.where(trainer_id:trainer.id)
	end
end
