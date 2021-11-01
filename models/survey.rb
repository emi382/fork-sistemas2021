# The survey class records what result a certain person got for the test in what date
class Survey < Sequel::Model
  many_to_one :careers

  def self.filter_by_date(start_date, finish_date)
    survey_struct = Struct.new(:career_id, :survey_id)
    surveys = Survey.all
    survey_array = []
    i = 0
    surveys.each do |survey|
      next unless DateTime.parse(start_date) < DateTime.parse(finish_date)

      next unless survey.created_at >= DateTime.parse(start_date) && survey.created_at <= DateTime.parse(finish_date).change(
        hour: 23, min: 59, sec: 59
      )

      survey_array[i] = survey_struct.new(survey.career_id, survey.survey_id)
      i += 1
    end
    survey_array
  end

  # this function returns a structure of careers and an accumulator representing the survey count of said careers
  def self.career_count(surveys)
    careers = Career.map_to_career_struct
    surveys.each do |s|
      careers.each do |c|
        c.acum = c.acum + 1 if s.career_id == c.career_id
      end
    end
    careers
  end

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name || name.empty?
  end
end
