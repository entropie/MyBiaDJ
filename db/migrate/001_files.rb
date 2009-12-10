#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ
  class MigrateFiles < Sequel::Migration
    def up
      create_table :files do
        primary_key       :id
        String       :foo
        String       :bar
        String       :batz        
      end
    end

    def down
      drop_table :files
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
