class OutcomeService

  # Deletes the outcome with id=oid and returns the question ID
  def self.delete_outcome(oid)
    qid = Outcome.questionid(oid)
    Outcome.where(outcome_id: oid).delete
    qid
  end

  # Creates a new outcome with a career ID, choice ID and weight
  # But only if the career exists
  def self.create_outcome(cid, chid, weight)
    career = Career.find(career_id: cid)
    outcome=Outcome.new(choice_id: chid, career_id: cid, weight: weight)
    if (career.nil? || !outcome.valid?)
      return
    end
      outcome.save
  end
end
