#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ
  module FSHelper
    def relative_path(rp = nil)
      (rp||@path).gsub(::File.expand_path(MyBiaDJ[:base_dir]) + "/", '')
    end

    # reads a directory recursively and returns each child with expanded_path
    def read_dir(dir, &blk)
      Dir.chdir(dir){
        Dir["*"].each do |folder|
          unless ::File.directory?(folder)
            yield ::File.expand_path(folder)
          else
            read_dir(folder, &blk) unless ::File.symlink?(folder)
          end
        end
      }
    end
    module_function :read_dir
    
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
