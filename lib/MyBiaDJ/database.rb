#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  module Database

    module Tables
    end
    
    def self.tables
      consts = Tables.constants.map{|const|
        Tables.const_get(const)
      }
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
