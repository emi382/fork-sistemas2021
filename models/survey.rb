class Survey < Sequel::Model
	many_to_one:careers
	
	def self.filterByDate(startDate, finishDate)
		 surveyStruct = Struct.new(:career_id, :survey_id)
		 surveys = Survey.all
		 surveyArray = Array.new
		 i = 0
		 surveys.each do |survey|
			if (DateTime.parse(startDate) < DateTime.parse(finishDate))
				if (survey.created_at >= DateTime.parse(startDate) && survey.created_at <= DateTime.parse(finishDate))
					surveyArray[i] = surveyStruct.new(survey.career_id, survey.survey_id)
					i=i+1
				end
			end
		end
		return surveyArray
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
