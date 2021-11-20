# Service class for surveys
class SurveyService
  # Returns the first and last elements from
  # the survey table, which is ordered by date, if surveys is not nil
  def self.first_and_last
    surveys = Survey.first
    if surveys.nil?
      [false, nil, nil]
    else
      first_date = Survey.first
      last_date = Survey.last
      [true, first_date, last_date]
    end
  end

  # Returns a structure with the career name and survey count
  def self.career_count_view(start_date, finish_date, career)
    surveys = Survey.filter_by_date(start_date, finish_date)
    Survey.career_count(surveys, career)
  end
end
