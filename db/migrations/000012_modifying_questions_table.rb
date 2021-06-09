Sequel.migration do
  up do
    alter_table(:questions) do
     add_foreign_key :choice_id, :choices
    end
  end

  down do
    drop_column :choice_id
  end
end