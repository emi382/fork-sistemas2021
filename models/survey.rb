class Survey < Sequel::Model
	#one_to_many:responses
	many_to_one:careers
	
	def validate
	  super 
	  errors.add(:name, 'cannot be empty') if !name || name.empty?
	end  
end
