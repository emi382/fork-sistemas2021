# Service class for questions
class QuestionService
  # Creates a question and a choice associated to it
  def self.create_question(desc)
    choice = Choice.create(value: -1)
    question = Question.new(description: desc, choice_id: choice.choice_id)
    unless question.valid?
      Choice.where(choice_id: choice.choice_id).delete
      return
    end
    question.save
  end

  # Given a question ID returns the question and the associated choice
  def self.question_and_choice(qid)
    question = Question.where(question_id: qid).last
    choice = Choice.where(choice_id: question.choice_id).last
    [question, choice]
  end
end
