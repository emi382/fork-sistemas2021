class Question < Sequel::Model
	#one_to_many:choices
	many_to_one:choices
	#one_to_many:responses

	#this function checks that theres at least 2 questions, and that they're each associated to at least one career through an outcome
	def self.first_two
      	question=Question.first(2)
      	return false if question.length < 2
      	check=true
      	question.each do |q| 
      		outcomes=Outcome.where(choice_id: q.choice_id)
      		l=outcomes.count
      		check = check && l>0
      	end
      	check
    end 

   	#deletes a question and its associated choice given the question id
   	def self.deleteq(qid)
   		question=Question.find(question_id: qid)
   		Choice.where(:choice_id => question.choice_id).delete
   		Question.where(:question_id => qid).delete
    end

	def validate
		super
		errors.add(:description, 'cannot be empty') if !description || description.empty?
    end
end
