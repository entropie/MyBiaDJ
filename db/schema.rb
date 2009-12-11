Class.new(Sequel::Migration) do
  def up
    create_table(:files) do
      primary_key :id
      String :path
      String :name
    end
    
    create_table(:files_relations) do
      Integer :parent_id
      Integer :files_id
    end
    
    create_table(:files_virtuals) do
      Integer :files_id
      Integer :virtual_id
    end
    
    create_table(:schema_info) do
      Integer :version
    end
    
    create_table(:virtuals) do
      primary_key :id
      String :name
      String :value
    end
  end
  
  def down
    drop_table(:files, :files_relations, :files_virtuals, :schema_info, :virtuals)
  end
end
