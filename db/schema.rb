Class.new(Sequel::Migration) do
  def up
    create_table(:files) do
      primary_key :id
      String :foo
      String :bar
      String :batz
    end
    
    create_table(:foo) do
      primary_key :id
    end
    
    create_table(:schema_info) do
      Integer :version
    end
  end
  
  def down
    drop_table(:files, :foo, :schema_info)
  end
end
