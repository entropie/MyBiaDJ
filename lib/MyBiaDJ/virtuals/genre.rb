#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

class MyBiaDJ::FileSystem
  class Virtual
    class Genre < Virtual

      def value
        super(record.genre)
      end
      
      def link_target
        genre_path = ::File.join(root, self.class.name.to_s, sanitize(record.genre))
        FileUtils.mkdir_p(genre_path)
        ::File.join(genre_path, sanitize(record.name))
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
