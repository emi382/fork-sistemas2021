require File.expand_path '../../test_helper.rb', __FILE__

class CareerTest < MiniTest::Unit::TestCase
MiniTest::Unit::TestCase
	
  def test_career_has_many_surveys
  
    #Arrange
    career = Career.create(name: 'Spaceman')
		
    #Act
    Survey.create(name: 'U1', career_id: career.career_id)
    Survey.create(name: 'U2', career_id: career.career_id)
    Survey.create(name: 'U3', career_id: career.career_id)
		
    #Assert
		
    assert_equal career.surveys.count, 3

  end
  
  def test_career_has_many_outcomes
  
    #Arrange
    career = Career.create(name: 'Spaceman')
		
    #Act
    Outcome.create(career_id: career.career_id)
    Outcome.create(career_id: career.career_id)
    Outcome.create(career_id: career.career_id)
		
    #Assert
		
    assert_equal career.outcomes.count, 3

  end
  
  def test_career_has_name
    career = Career.new
    
    career.name=''
    
    assert_equal career.valid?, false
  end
  
  def test_career_name_is_not_null
    career = Career.new
    
    career.name=nil
    
    assert_equal career.valid?, false
  end  
  

end
