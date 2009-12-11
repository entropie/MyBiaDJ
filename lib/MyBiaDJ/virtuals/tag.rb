#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

class MyBiaDJ::FileSystem
  class Virtual
    class Tag < Virtual

      def value
        super(record.tags.map{|t, i| t.to_s})
      end

      def link_target
        record.tags.map do |tag, count|          
          ::File.join(root, self.class.name.to_s, tag.to_s, sanitized_virtual_target)
        end
      end

      def link!
        link_target.each do |tagdir|
          FileUtils.mkdir_p(::File.dirname(tagdir))
          FileUtils.ln_s(record.path, tagdir, :verbose => MyBiaDJ.debug?)
        end
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
