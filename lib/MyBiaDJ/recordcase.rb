#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class RecordCase

    def initialize(basedir)
      @basedir = File.expand_path(basedir)
      raise CantFindHisRecordCase, "#{@basedir} does not exist." unless
        File.exist?(@basedir)
      

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