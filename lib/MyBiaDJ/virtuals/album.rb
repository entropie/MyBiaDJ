#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

class MyBiaDJ::FileSystem
  class Virtual
    class Album < Virtual
      def value
        super(record.album)
      end
      
      def link_target(target = nil)
        album_path = ::File.join(self.class.path)
        FileUtils.mkdir_p(album_path)
        ::File.join(album_path, virtual_target)
      end

      def virtual_target
        sanitize(record.name)
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
