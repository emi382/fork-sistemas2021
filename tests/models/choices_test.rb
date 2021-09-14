require File.expand_path '../../test_helper.rb', __FILE__

class ChoiceTest < MiniTest::Unit::TestCase
MiniTest::Unit::TestCase

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
