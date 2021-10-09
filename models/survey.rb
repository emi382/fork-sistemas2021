class Survey < Sequel::Model
	many_to_one:careers

	def self.startDate()
		#Devuelve la fecha mas antigua de la tabla Surveys.
	end

	def self.finishDate()
		#Devuelve al fecha mas reciente de la tabla Surveys
	end

	def self.filterbyDate(startDate, finishDate)
 		#TODO:make this function return all surveys within the specified dates
	end

	#this function returns a structure of careers and an accumulator representing the survey count of said careers
	def self.careerCount(surveys)
		careers=Career.mapToCareerStruct
		surveys.each do |s|
			careers.each do |c|
				if (s.career_id == c.career_id)
					c.acum=c.acum+1
				end
			end
		end
		return careers
	end
	
	def validate
	  super 
	  errors.add(:name, 'cannot be empty') if !name || name.empty?
	end  

end
