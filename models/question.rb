class Question < Sequel::Model
	#one_to_many:choices
	many_to_one:choices
	#one_to_many:responses

	#this function checks that theres at least 2 questions, and that they each have at least one outcome
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
   	def self.deleteq(id)
   		Question.where(:question_id => params[:id]).delete
    	Choice.where(:choice_id => params[:choice_id]).delete
    end

	def validate
		super
		errors.add(:description, 'cannot be empty') if !description || description.empty?
    end
end
