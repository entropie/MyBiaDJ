#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class FileSystem

    class Mirror
      attr_reader :path
      
    end

    class Fuse < Mirror

      def initialize
        @path = ::File.expand_path("~/MyBiadDJFuse")
        FileUtils.mkdir_p(path)
        virtual_dispatcher = VirtualDispatcher.new
        FuseFS.set_root(virtual_dispatcher)
        umount # force umount
        FuseFS.mount_under(path)
        MyBiaDJ::Info("Mounting Fuse Filesystem under #{path}")
        trap("INT") { FuseFS.exit }
        FuseFS.run
      end
      
      def umount
        system("umount #{path}")
      end
      
    end
    

    class VirtualDispatcher < FuseFS::FuseDir

      def initialize
        @vdirs = Virtual.all
      end
      
      def select_virtual_for(path)
        @vdirs.select{|v| v.name == path.to_sym}.first
      end
      
      def dispatch_path(path)
        virtual_path, *rest = scan_path(path)
        virtual = select_virtual_for(virtual_path)
        virtual.contents(rest)
      rescue
        p $!
      end

      def contents(path)
        MyBiaDJ::Debug("fuse>contents: %s " % path)
        case path
        when "/"
          @vdirs.map{|virtual| virtual.name.to_s }
        else
          dispatch_path(path)
        end
      end
      
      def directory?(path)
        spath, *rest = scan_path(path)
        if spath and rest and rest.size == 0
          @vdirs.map{|v| v.name}.include?(spath.to_sym)
        else
          virtual = select_virtual_for(spath)
          virtual.directory?(rest)
        end
      end
      
      def size(path)
        read_file(path).size
      end

      def file?(path)
        path == '/hello.txt'
      end

      def read_file(path)
        "Hello, World!\n"
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
