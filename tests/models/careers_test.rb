require File.expand_path '../../test_helper.rb', __FILE__

class CareerTest < MiniTest::Unit::TestCase
	MiniTest::Unit::TestCase
	
	def test_career_has_many_surveys
		#Arrange
		career = Career.create(name: 'Spaceman')
		
		#Act
		Survey.create(name: 'U1', career_id: career.id)
		Survey.create(name: 'U2', career_id: career.id)
		Survey.create(name: 'U3', career_id: career.id)
		
		#Assert
		
		assert_equal(career.surveys.count, 3)
	end

end
