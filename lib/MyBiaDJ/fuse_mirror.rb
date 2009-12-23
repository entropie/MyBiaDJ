#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#



module MyBiaDJ
  class FileSystem

    class FuseMirror
      def initialize
        @path = ::File.expand_path("~/MyBiaDJFuse")
        FileUtils.mkdir_p(@path)
        virtual_dispatcher = Dispatcher.new
        FuseFS.set_root(virtual_dispatcher)
        umount # force umount
        FuseFS.mount_under(@path)
        MyBiaDJ::Info("Mounting Fuse Filesystem under #{@path}")
        trap("INT") { FuseFS.exit }
        FuseFS.run
      end
      
      def umount
        system("umount #{@path}")
      end
      
    end

    class Dispatcher
      
      def initialize
        @virtuals = Virtual.all.map{|v| v.new }
      end

      def rest_for(path)
        spath_ary = path.split("/").reject{|p| p.empty?}
        spath, *rest = spath_ary
        rest
      end
      
      def dispatcher_for(path)
        spath_ary = path.split("/").reject{|p| p.empty?}
        spath, *rest = spath_ary
        @virtuals.select{|v| v.name.to_s == spath}.first
      rescue
        p $!
      end
      
      def dispatch_for(path)
        dispatcher = path == "/" ? self : dispatcher_for(path)
        dispatcher
      end
      
      def contents(path)
        dispatch_for(path).dispatched_content(rest_for(path)) if dispatch_for(path)
      rescue
        p $!
      end

      def file?(path)
        dispatch_for(path).dispatched_file?(rest_for(path)) if dispatch_for(path)
      rescue
        p $!
      end

      def directory?(path)
        dispatch_for(path).dispatched_directory?(rest_for(path)) if dispatch_for(path)
      rescue
        p $!
      end
      
      # toplevel content
      def dispatched_content(rest)
        @virtuals.map{|v| v.name.to_s}
      end

      def dispatched_directory?(path)
        p 23
        @virtuals.map{|v| "/#{v.name}"}.include?(path)
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
