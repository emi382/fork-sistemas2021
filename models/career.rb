# This class includes possible careers that our test can return
class Career < Sequel::Model
  plugin :validation_helpers
  one_to_many :surveys
  one_to_many :outcomes

  # Given all the careers, maps them to an array of structures with id, name and acum
  def self.map_to_career_struct
    career_struct = Struct.new(:career_id, :name, :acum)
    careers = Career.all
    career_array = []
    i = 0
    careers.each do |career|
      career_array[i] = career_struct.new(career.career_id, career.name, 0)
      i += 1
    end
    career_array
  end

  # Given a career_array with all its accumulators set, calculates
  # which one has the highest acum value and returns the element
  def self.best_career_calc(carray)
    max = 0
    career_id = 0
    final_career = carray[0]
    carray.each do |k|
      next unless k.acum >= max

      max = k.acum
      career_id = k.career_id
      final_career = k
    end
    final_career
  end

  def validate
    super
    validates_presence :name, message: 'Requiere nombre de carrera'
    validates_unique :name, message: 'No puede haber carreras repetidas'
  end
end
