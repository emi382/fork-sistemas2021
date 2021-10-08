class Career < Sequel::Model
	one_to_many:surveys
	one_to_many:outcomes

	#Given all the careers, maps them to an array of structures that have the career id, name, and an accumulator
	def self.mapToCareerStruct
		careerStruct=Struct.new(:career_id,:name,:acum)
		careers=Career.all
		careerArray=Array.new
		i=0
		careers.each do |career|
      		careerArray[i]=careerStruct.new(career.career_id,career.name,0)
      		i=i+1
      	end
      	return careerArray
    end

    #Given a careerArray with all its accumulators set, calculates which one has the highest acum value and returns the careerStruct
    def self.bestCareerCalc(carray)
    	max=0
    	careerid=0
    	finalcareer=carray[0]
    	carray.each do |k|
      		if k.acum>=max
        		max=k.acum
        		careerid=k.career_id
        		finalcareer=k
     		end
    	end
    	return finalcareer
    end

	def validate
	  super 
	  errors.add(:name, 'cannot be empty') if !name || name.empty?
	end  
end
