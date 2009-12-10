#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ
  class MigrateFoo < Sequel::Migration

    def up
      create_table :foo do
        primary_key       :id
        String            :bar
      end
    end

    def down
      drop_table :foo
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
