Sequel.migration do
  up do
    alter_table(:questions) do
      drop_column :type
    end
  end

  down do
    alter_table(:questions) do
      add_column :type, String
    end
  end
end
