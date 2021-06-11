Sequel.migration do
  up do
    alter_table(:choices) do
      drop_foreign_key(:survey_id)
    end
  end

  down do
    alter_table(:choices) do
      add_foreign_key :survey_id, :surveys
    end
  end
end