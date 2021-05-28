Sequel.migration do
  up do
    alter_table(:choices) do
      add_column :value, Integer
     drop_column :text
     add_foreign_key :survey_id, :surveys
    end
  end

  down do
    drop_column :survey_id
    add_column :text
  end
end