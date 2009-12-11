#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

class MyBiaDJ::FileSystem
  class Virtual
    class Artist < Virtual

      def value
        super(record.artist)
      end

      def link_target(target = nil)
        artist_path = ::File.join(self.class.path, sanitize(record.artist))
        FileUtils.mkdir_p(artist_path)
        ::File.join(artist_path, sanitize(record.name))
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
