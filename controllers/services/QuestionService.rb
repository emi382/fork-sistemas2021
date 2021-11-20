class QuestionService
  def self.create_question(desc)
    choice = Choice.create(value: -1)
    question = Question.new(description: desc, choice_id: choice.choice_id)
    unless question.valid?
      Choice.where(choice_id: choice.choice_id).delete
      return
    end
    question.save
  end

  def self.question_and_choice(qid)
    question = Question.where(question_id: qid).last
    choice = Choice.where(choice_id: question.choice_id).last
    [question, choice]
  end
end
