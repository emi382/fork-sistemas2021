class OutcomeService
  def self.delete_outcome(oid)
    qid = Outcome.questionid(oid)
    Outcome.where(outcome_id: oid).delete
    qid
  end

  def self.create_outcome(cid, chid, weight)
    career = Career.find(career_id: cid)
    Outcome.create(choice_id: chid, career_id: cid, weight: weight) unless career.nil?
  end
end
