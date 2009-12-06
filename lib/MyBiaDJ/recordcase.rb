#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class Records < Array
  end
  
  class RecordCase

    attr_reader :basedir
    attr_accessor :quiet
    attr_accessor :records
    
    def initialize(basedir)
      @basedir = ::File.expand_path(basedir)
      raise CantFindHisRecord, "#{@basedir} does not exist." unless
        ::File.exist?(@basedir)
      @records = Records.new
    end

    def quiet?
      @quiet || false
    end

    def read_dir(dir, &blk)
      Dir.chdir(dir){
        Dir["*"].each do |folder|
          unless ::File.directory?(folder)
            yield ::File.expand_path(folder)
          else
            read_dir(folder, &blk)
          end
        end
      }
    end
    
    def update
      STDOUT.sync = !STDOUT.sync
      record = dir = old = nil
      read_dir(basedir) do |file|
        pfile = Pow(file)
        dir = pfile.parent.name
        if old != dir
          record = Record.new(dir)
          @records << record
          unless quiet?
            puts
            print " >>> ", dir, " "
          end
        else
          record.tracks << Track.new(file)
          print "." unless quiet?
        end
        old = dir
      end
      STDOUT.sync = !STDOUT.sync      
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
