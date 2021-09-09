class Career < Sequel::Model
	one_to_many:surveys
	one_to_many:outcomes

	#Given all the careers, maps them to an array of structures that have the career id, name, and an accumulator
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
