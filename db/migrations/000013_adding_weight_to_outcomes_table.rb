Sequel.migration do
  up do
    alter_table(:outcomes) do
      add_column :weight, Integer
    end
  end

  down do
    alter_table(:outcomes) do
      drop_column :weight
    end
  end
end