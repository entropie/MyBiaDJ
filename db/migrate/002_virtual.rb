#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ
  class MigrateVirtual < Sequel::Migration

    def up
      create_table :virtuals do
        primary_key       :id

        String       :name
        String       :value
      end

      create_table :files_virtuals do
        foreign_key :files_id
        foreign_key :virtual_id
      end
    end

    def down
      drop_table :virtuals
    end
    
  end
end



=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end
