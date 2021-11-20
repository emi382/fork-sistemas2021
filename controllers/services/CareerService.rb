class CareerService
  def self.create_career(career_name)
    career = Career.new(name: career_name)
    return unless career.valid?
    career.save
  end
end
