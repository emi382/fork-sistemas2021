class Outcome < Sequel::Model
	many_to_one:choices
	many_to_one:careers

	#returns the question id of the question an outcome is associated to through choice, given the outcome id
	def self.questionid(oid)
		outcome=Outcome.find(:outcome_id => oid)
    	question=Question.find(:choice_id => outcome.choice_id)
    	return question.question_id
	end

	#Given an array of career ids and accumulators for each career, 
	#iterates over all outcomes, and for every career that is associated with that outcome
	#multiplies the user-selected choice value by the outcome weight, then adds it to the
	#respective career's accumulator
	def self.setWeightedValues(cArray)
		outcomes=Outcome.all
		outcomes.map do |outcome|
      		cArray.each do |k|
        		if k.career_id == outcome.career_id
        			choice=Choice.find(choice_id: outcome.choice_id)
     				curr=outcome.weight * choice.value
          			k.acum+=curr
        		end
      		end
      	end
	end

end
