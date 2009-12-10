Class.new(Sequel::Migration) do
  def up
    create_table(:files) do
      primary_key :id
      Integer :parent_id
      String :foo
      String :bar
      String :batz
    end
    
    create_table(:files_relations) do
      Integer :parent_id
      Integer :files_id
    end
    
    create_table(:foo) do
      primary_key :id
      String :bar
    end
    
    create_table(:schema_info) do
      Integer :version
    end
  end
  
  def down
    drop_table(:files, :files_relations, :foo, :schema_info)
  end
end
