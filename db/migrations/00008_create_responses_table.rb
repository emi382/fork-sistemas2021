Sequel.migration do
  up do
    create_table(:responses) do
      primary_key   :response_id
      foreign_key   :survey_id,   :surveys, null:true
      foreign_key   :choice_id,   :choices, null:true
      foreign_key   :question_id, :questions, null:true
      DateTime      :created_at,   default: Sequel::CURRENT_TIMESTAMP
      DateTime      :updated_at,   default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:responses)
  end
end
