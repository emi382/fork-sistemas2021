Sequel.migration do
  up do
    alter_table(:questions) do
      drop_column :name
      drop_column :number
    end
  end

  down do
    alter_table(:questions) do
      add_column :name, String
      add_column :number, Integer
    end
  end
end