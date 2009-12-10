#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ::Database::Tables

  class Files < Sequel::Model

    many_to_many :parent, :class => Files, :join_table => :files_relations
    
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
