# Service class for the test-solving logic
class TestLogicService
  # Calculates the score for each career, as well as the highest one
  def self.calculate_answer
    career_array = Career.map_to_career_struct
    Outcome.calc_weighted_values(career_array)
    best_career = Career.best_career_calc(career_array)
    [career_array, best_career]
  end
end
