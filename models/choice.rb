class Choice < Sequel::Model
	#many_to_one:questions
	one_to_one:questions
	#one_to_many:responses
	one_to_many:outcomes
	many_to_one:survey

	def validate
	  super 
	  errors.add(:text, 'cannot be empty') if !text || text.empty?
	end  


end

