# The survey class records what result a certain person got for the test in what date
class Survey < Sequel::Model
  many_to_one :careers

  # this function returns all the surveys between the dates start and finish
  def self.filter_by_date(start_date, finish_date)
    survey_struct = Struct.new(:career_id, :survey_id)
    surveys = Survey.all
    survey_array = []
    i = 0
    surveys.each do |survey|
      next unless Survey.date_within_range(survey, start_date, finish_date)

      survey_array[i] = survey_struct.new(survey.career_id, survey.survey_id)
      i += 1
    end
    survey_array
  end

  # this function checks that the date is valid, and in range of the start and finish date
  def self.date_within_range(survey, start, finish)
    valid = DateTime.parse(start) < DateTime.parse(finish)
    in_range = survey.created_at >= DateTime.parse(start) &&
               survey.created_at <= DateTime.parse(finish).change(hour: 23, min: 59, sec: 59)
    valid and in_range
  end

  # Returns a structure with the career's (given by cid) name and number of times it appears in surveys
  def self.career_count(surveys,cid)
    career_struct = Struct.new(:career_name, :surveycount)
    career = Career.find(career_id: cid)
    career_surveys = career_struct.new(career.name, 0)
    surveys.each do |s|
      if (s.career_id == career.career_id)
        career_surveys.surveycount+=1
      end
    end
    return career_surveys
  end

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name || name.empty?
  end
end
