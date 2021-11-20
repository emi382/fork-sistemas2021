class SurveyService
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

  def self.career_count_view(start_date, finish_date, career)
    surveys = Survey.filter_by_date(start_date, finish_date)
    careers = Survey.career_count(surveys)
    career = Career.find(career_id: career).name
    [careers, career]
  end
end
