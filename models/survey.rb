class Survey < Sequel::Model
	many_to_one:careers

	def self.filterbyDate(startDate,finishDate)
 		#TODO:make this function return all surveys within the specified dates
	end

	def self.careerCount(surveys)
		#TODO:make this function return a structure of careers and survey counts of said careers
	end
	
	def validate
	  super 
	  errors.add(:name, 'cannot be empty') if !name || name.empty?
	end  
end
