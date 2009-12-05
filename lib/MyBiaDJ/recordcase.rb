#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class RecordCase

    attr_reader :basedir
    
    def initialize(basedir)
      @basedir = File.expand_path(basedir)
      raise CantFindHisRecord, "#{@basedir} does not exist." unless
        File.exist?(@basedir)
    end

    def read_dir(dir, &blk)
      Dir.chdir(dir){
        Dir["*"].each do |folder|
          unless File.directory?(folder)
            yield File.expand_path(folder)
          else
            read_dir(folder, &blk)
          end
        end
      }
    end
    
    def update
      STDOUT.sync = true
      dir = old = nil
      read_dir(basedir) do |file|
        sleep 0.5
        pfile = Pow(file)
        dir = pfile.parent.name
        if old != dir
          puts
          print dir, " "
        else
          print "."
        end
        old = dir
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
