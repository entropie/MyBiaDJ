#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

class MyBiaDJ::FileSystem
  class Virtual
    class Album < Virtual

      def db
        super[name]
      end
      
      def dispatched_content(path)
        if path.empty?
          conts = MyBiaDJ::Table(:virtual).filter(:name => name.to_s)
          conts.map do |rec|
            ret = rec[:value]
            db[ret] = []
            rec.files.each do |rc|
              rc.children.each do |child|
                db[ret] << File.basename(child[:path])
              end
            end
            ret
          end
        else
          db[path.to_s]
        end
      end

      def dispatched_directory?(path)
        return true if path.empty?
        return false unless db[path.to_s]
        true
      end
      
      def dispatched_file?(path)
        return false if path.to_s =~ /^\./
        if path.size == 1
          return false
        end
        db[ path.first ].include?(path.last)
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
