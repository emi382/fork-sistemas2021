require File.expand_path '../../test_helper.rb', __FILE__

class ChoiceTest < MiniTest::Unit::TestCase
MiniTest::Unit::TestCase
	
  def test_choice_has_one_question
  
    #Arrange

    question=Question.create(description:'a')
    
    #Act

    choice1 = Choice.create(question_id:question.question_id)
    choice2 = Choice.create(question_id:question.question_id)

    #Assert
		
    assert_equal (choice1.question_id == choice2.question_id), true

  end

  def test_choice_has_many_outcomes
  
    #Arrange
    choice = Choice.create()
    
    #Act
    Outcome.create(choice_id: choice.choice_id)
    Outcome.create(choice_id: choice.choice_id)
    
    #Assert
    
    assert_equal choice.outcomes.count, 2

  end
end
