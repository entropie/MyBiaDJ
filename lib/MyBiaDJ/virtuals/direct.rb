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
        direct_path
      end

      def self.size(path)
        return false if path[1] =~ /^\./
        virt = MyBiaDJ::Database::Tables::Virtual
        f = virt.filter(:name => "direct", :value => path.first)
        f.each do |fk|
          ret = fk.files.map{|file|
            file.children.select{|fc| ::File.basename(fc.path) == path.last}.map{|c| c.to_realpath}
          }.flatten
          return ::File.size(ret.first)
        end
      rescue
        p "virt>size>#{path}: #{$!}"
        0
      end
      
      def self.read_file(path)
        return false if path[1] =~ /^\./
        virt = MyBiaDJ::Database::Tables::Virtual
        f = virt.filter(:name => "direct", :value => path.first)
        f.each do |fk|
          return fk.files.map{|file|
            file.children.map{|fc| File.basename(fc[:path])}.include?(path.last)
          }.flatten
        end
      end

      def self.file?(path)
        return false if path[1] =~ /^\./
        path.size == 2
      end

      def self.directory?(path)
        return false if path.size > 1
        virt = MyBiaDJ::Database::Tables::Virtual
        f = virt.filter(:name => "direct", :value => path.first)
        f.count == 1
      rescue
        puts "virt>#{path}: #{$!}"
        false
      end
      
      def self.contents(path)
        virt = MyBiaDJ::Database::Tables::Virtual
        f = virt.filter(:name => "direct")
        if path.empty?
          f.map do |r|
            r.value
          end
        else
          f.filter(:value => path.join).each do |a|
            return a.files.first.children.map{|child| File.basename(child[:path])}
          end
        end
      rescue
        p $!
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
