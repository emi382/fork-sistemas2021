class Question < Sequel::Model
	#one_to_many:choices
	many_to_one:choices
	#one_to_many:responses

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

	def validate
		super
		errors.add(:description, 'cannot be empty') if !description || description.empty?
    end
end
