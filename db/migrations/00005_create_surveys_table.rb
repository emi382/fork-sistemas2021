Sequel.migration do
  up do
    create_table(:surveys) do
      primary_key   :survey_id
      String 	    :name
      foreign_key   :career_id, :careers, null:true
      DateTime      :created_at,   default: Sequel::CURRENT_TIMESTAMP
      DateTime      :updated_at,   default: Sequel::CURRENT_TIMESTAMP
    end
  end

  down do
    drop_table(:surveys)
  end
end
