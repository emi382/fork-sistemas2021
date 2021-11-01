require File.expand_path '../test_helper.rb', __dir__

# Test to determine outcomes is working properly
class OutcomeTest < MiniTest::Unit::TestCase
  MiniTest::Unit::TestCase

  def test_outcome_has_one_career
    # Arrange
    career = Career.create(name: 'C1')

    # Act
    outcome1 = Outcome.create(career_id: career.career_id)
    outcome2 = Outcome.create(career_id: career.career_id)

    # Assert
    assert_equal (outcome1.career_id == outcome2.career_id), true
  end

  def test_outcome_has_one_choice
    # Arrange
    choice = Choice.create

    # Act
    outcome1 = Outcome.create(choice_id: choice.choice_id)
    outcome2 = Outcome.create(choice_id: choice.choice_id)

    # Assert
    assert_equal (outcome1.choice_id == outcome2.choice_id), true
  end
end
