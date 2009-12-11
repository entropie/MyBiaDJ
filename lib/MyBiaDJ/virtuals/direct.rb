#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

class MyBiaDJ::FileSystem
  class Virtual
    class Direct < Virtual

      def value
        super(::File.basename(record.path))
      end

      def link_target(target = nil)
        direct_path = ::File.join(self.class.path, ::File.basename(record.path))
        FileUtils.mkdir_p(direct_path)
        direct_path
      end
      
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
