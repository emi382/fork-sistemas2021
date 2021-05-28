Sequel.migration do
  up do
    alter_table(:choices) do
     add_column :value, Integer
    end
  end

  down do
    drop_column :value
  end
end