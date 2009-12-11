#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ::Database::Tables

  class Virtual < Sequel::Model

    many_to_many :files, :class => Files, :right_key => :files_id

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
