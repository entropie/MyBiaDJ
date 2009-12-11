#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  # recordcase is the entire music collection
  class RecordCase

    include FSHelper
    
    attr_reader :basedir
    attr_accessor :quiet
    attr_accessor :records
    
    def initialize(basedir)
      @basedir = ::File.expand_path(basedir)
      raise CantFindHisRecord, "#{@basedir} does not exist." unless
        ::File.exist?(@basedir)
      @records = Records.new
    end

    def size
      records.size
    end

    # starts import process from filesystem
    def import!
      MyBiaDJ::FileSystem.import(self)
    end
    
    def stats
      rc = @records
      puts "Albums: "
      pp records.albums
      puts "Genres: "    
      pp records.genres
      puts "Artists: "        
      pp records.artists
    end

    def quiet?
      @quiet || false
    end

    # reads +tdir+ or +basedir+ and collects all records/tracks
    def read(tdir = nil)
      STDOUT.sync = !STDOUT.sync
      record = dir = old = nil
      read_dir(tdir || basedir) do |file|
        dir = ::File.dirname(file)
        if old != dir
          record = Record.new(dir)
          @records << record
          unless quiet?
            puts
            print " >>> ", dir, " "
          end
          old = dir
        else
          print "." unless quiet?
        end
        record.tracks << Track.new(file)
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
