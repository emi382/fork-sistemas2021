Sequel.migration do
  up do
    create_table(:outcomes) do
      primary_key   :outcome_id
      foreign_key   :career_id, :careers, null:true
      foreign_key   :choice_id, :choices, null:true
      DateTime      :created_at,   default: Sequel::CURRENT_TIMESTAMP
      DateTime      :updated_at,   default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:outcomes)
  end
end
