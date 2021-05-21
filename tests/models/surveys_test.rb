require File.expand_path '../../test_helper.rb', __FILE__

class SurveyTest < MiniTest::Unit::TestCase
MiniTest::Unit::TestCase
	
  def test_survey_has_one_career
  
    #Arrange

    career=Career.create(name: 'C1')
    
    #Act

    survey1 = Survey.create(name: 'S1',career_id:career.career_id)
    survey2 = Survey.create(name: 'S2',career_id:career.career_id)

    #Assert
		
    assert_equal (survey1.career_id == survey2.career_id), true

  end
  
  def test_survey_has_many_responses
  
    #Arrange
    survey = Survey.create(name: 'S1')
		
    #Act
    Response.create(survey_id: survey.survey_id)
    Response.create(survey_id: survey.survey_id)
		
    #Assert
		
    assert_equal survey.responses.count, 2

  end
  
  def test_survey_has_name
    survey = Survey.new
    
    survey.name=''
    
    assert_equal survey.valid?, false
  end
  
  def test_survey_name_is_not_null
    survey = Survey.new
    
    survey.name=nil
    
    assert_equal survey.valid?, false
  end
  

end
