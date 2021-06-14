Sequel.migration do
  up do
    alter_table(:outcomes) do
      drop_foreign_key [:career_id], name: :outcomes_career_id_fkey
      drop_foreign_key [:choice_id], name: :outcomes_choice_id_fkey
      add_foreign_key [:choice_id], :choices, on_delete: :cascade
      add_foreign_key [:career_id], :careers, on_delete: :cascade
    end
    alter_table(:surveys) do
        drop_foreign_key [:career_id], name: :surveys_career_id_fkey
        add_foreign_key [:career_id], :careers, on_delete: :cascade
    end
    alter_table(:questions) do
        drop_foreign_key [:choice_id], name: :questions_choice_id_fkey
        add_foreign_key [:choice_id], :choices, on_delete: :cascade
    end
  end

  down do
    alter_table(:outcomes) do
      drop_foreign_key [:career_id], name: :outcomes_career_id_fkey
      drop_foreign_key [:choice_id], name: :outcomes_choice_id_fkey
      add_foreign_key [:choice_id], :choices
      add_foreign_key [:career_id], :careers
    end
    alter_table(:surveys) do
      drop_foreign_key [:career_id], name: :surveys_career_id_fkey
      add_foreign_key [:career_id], :careers
    end
    alter_table(:questions) do
        drop_foreign_key [:choice_id], name: :questions_choice_id_fkey
        add_foreign_key [:choice_id], :choices
    end
  end
end