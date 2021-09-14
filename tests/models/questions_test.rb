require File.expand_path '../../test_helper.rb', __FILE__

class QuestionTest < MiniTest::Unit::TestCase
MiniTest::Unit::TestCase

  def test_question_has_one_choice
    #Arrange
  	choice=Choice.create()

    #Act
   	question1=Question.create(description: 'a')
   	question2=Question.create(description: 'b')

    #Assert
   	assert_equal (question1.choice_id == question2.choice_id), true
  end

  def test_question_description_is_not_null
    #Arrange
    question = Question.new

    #Act
    question.description = nil

    #Assert
    assert_equal question.valid?, false
  end

  def test_question_description_is_not_empty
    #Arrange
    question = Question.new

    #Act
    question.description = ''

    #Assert
    assert_equal question.valid?, false
  end
end
