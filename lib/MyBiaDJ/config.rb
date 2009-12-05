#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  
  class Config < Hash
    Defaults = {
      :colors => :true,
      :debug => 5,
      :record_case => "~/Music/tie"
    }

    def initialize(hsh = {})
      self.update(Defaults.merge(hsh))
    end

    def inspect
      "<Config:#{super}>"
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
