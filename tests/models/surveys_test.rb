require File.expand_path '../../test_helper.rb', __FILE__

#Test to determine surveys is working properly
class SurveyTest < MiniTest::Unit::TestCase
MiniTest::Unit::TestCase

  def test_survey_has_one_career
    #Arrange
    career=Career.create(name: 'C1')

    #Act
    survey1 = Survey.create(name: 'S1', career_id: career.career_id)
    survey2 = Survey.create(name: 'S2', career_id: career.career_id)

    #Assert
    assert_equal (survey1.career_id == survey2.career_id), true

  end

  def test_survey_has_name
		#Arrange
    survey = Survey.new

		#Act
    survey.name = ''

		#Assert
    assert_equal survey.valid?, false
  end

  def test_survey_name_is_not_null
		#Arrange
    survey = Survey.new

    #Act
    survey.name = nil

    #Assert
    assert_equal survey.valid?, false
  end

end
