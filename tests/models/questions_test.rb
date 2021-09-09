require File.expand_path '../../test_helper.rb', __FILE__

class QuestionTest < MiniTest::Unit::TestCase
MiniTest::Unit::TestCase

  #= def test_question_has_one_choice

    #Arrange
#    choice=Choice.create()

    #Act
#    question1=Question.create(description:'a')
#    question2=Question.create(description:'b')

    #Assert

#    assert_equal (question1.choice_id == question2.choice_id), true

  #= end

  def test_question_description_is_not_null
    question = Question.new

    question.description=nil

    assert_equal question.valid?, false
  end

  def test_question_description_is_not_empty
    question = Question.new

    question.description=''

    assert_equal question.valid?, false
  end

	def test_question_first_two_true
		#Arrange
		question1 = Question.create(description:'a')
    question2 = Question.create(description:'b')
		choice = Choice.create()
		#Act
		Outcome.create(choice_id: choice.choice_id)
		Outcome.create(choice_id: choice.choice_id)
		#Assert
		assert_equal Question.first_two, false
	end

	def test_question_first_two_false
		#Arrange
		choice = Choice.create()
		#Act
		Outcome.create(choice_id: choice.choice_id)
		Outcome.create(choice_id: choice.choice_id)
		#Assert
		assert_equal Question.first_two, false
	end
end
