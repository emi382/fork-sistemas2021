Sequel.migration do
  up do
    alter_table(:responses) do
      drop_foreign_key :question_id
      drop_foreign_key :choice_id
      drop_foreign_key :survey_id
    end
  end

  down do
    alter_table(:choices) do
      add_foreign_key :question_id, :questions
      add_foreign_key :choice_id, :choices
      add_foreign_key :survey_id, :surveys
    end
  end
end