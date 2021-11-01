require File.expand_path '../test_helper.rb', __dir__

# Test to determine careers is working properly
class CareerTest < MiniTest::Unit::TestCase
  MiniTest::Unit::TestCase
  def test_career_has_many_surveys
    # Arrange
    career = Career.create(name: 'Spaceman')

    # Act
    Survey.create(name: 'U1', career_id: career.career_id)
    Survey.create(name: 'U2', career_id: career.career_id)
    Survey.create(name: 'U3', career_id: career.career_id)

    # Assert
    assert_equal career.surveys.count, 3
  end

  def test_career_has_many_outcomes
    # Arrange
    career = Career.create(name: 'Spaceman')

    # Act
    Outcome.create(career_id: career.career_id)
    Outcome.create(career_id: career.career_id)
    Outcome.create(career_id: career.career_id)

    # Assert
    assert_equal career.outcomes.count, 3
  end

  def test_career_has_name
    # Arrange
    career = Career.new

    # Act
    career.name = ''

    # Assert
    assert_equal career.valid?, false
  end

  def test_career_name_is_not_null
    # Arrange
    career = Career.new

    # Act
    career.name = nil

    # Assert
    assert_equal career.valid?, false
  end
end
