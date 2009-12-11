#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ::Database::Tables

  class Files < Sequel::Model

    many_to_many :parent, :class => Files, :join_table => :files_relations

    many_to_many  :virtual, :join_table => :files_virtuals
    
    def parent
      par = super
      return par.kind_of?(Array) ? par.first : nil
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
