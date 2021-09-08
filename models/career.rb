class Career < Sequel::Model
	one_to_many:surveys
	one_to_many:outcomes

	def self.mapToCareerStruct
		careerStruct=Struct.new(:career_id,:name,:acum)
		careers=Career.all
		careerArray=Array.new
		i=0
		careers.map do |career|
      		careerArray[i]=careerStruct.new(career.career_id,career.name,0)
      		i=i+1;
      	end
      	return careerArray
    end
	
	def validate
	  super 
	  errors.add(:name, 'cannot be empty') if !name || name.empty?
	end  
end
