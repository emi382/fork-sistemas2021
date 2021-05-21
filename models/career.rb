class Career < Sequel::Model
	one_to_many:surveys
	one_to_many:outcomes
	
	def validate
	  super 
	  errors.add(:name, 'cannot be empty') if !name || name.empty?
	end  
end
