require File.expand_path '../../test_helper.rb', __FILE__

class ResponseTest < MiniTest::Unit::TestCase
MiniTest::Unit::TestCase

  def test_response_has_one_choice
    #Arrange
    choice=Choice.create(text: 'a')

    #Act
    response1 = Response.create(choice_id: choice.choice_id)
    response2 = Response.create(choice_id: choice.choice_id)

    #Assert
    assert_equal (response1.choice_id == response2.choice_id), true
  end

  def test_response_has_one_question
    #Arrange
    question=Question.create(name: 'Q1', description: "asd", number: 3, type: "asdasg")

    #Act
    response1 = Response.create(question_id: question.question_id)
    response2 = Response.create(question_id: question.question_id)

    #Assert
    assert_equal (response1.question_id == response2.question_id), true
  end

  def test_response_has_one_survey
    #Arrange
    survey=Survey.create(name: 'S1')

    #Act
    response1 = Response.create(survey_id: survey.survey_id)
    response2 = Response.create(survey_id: survey.survey_id)

    #Assert
    assert_equal (response1.survey_id == response2.survey_id), true
  end
end
