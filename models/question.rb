class Question < Sequel::Model
	#one_to_many:choices
	many_to_one:choices
	#one_to_many:responses

	def validate
		super
		errors.add(:description, 'cannot be empty') if !description || description.empty?
    end
end
