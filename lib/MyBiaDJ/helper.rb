#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ
  module FSHelper
    def relative_path(rp = nil)
      (rp||@path).gsub(::File.expand_path(MyBiaDJ[:base_dir]) + "/", '')
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
