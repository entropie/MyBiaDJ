#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  # holds a directory
  class Records < Array

    def artists
      map{|r| r.artist}
    end

    def genres
      map{|r| r.genre}
    end

    def albums
      map{|r| r.album}
    end

  end
  
  # recordcase is the entire music collection
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

    def size
      records.size
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

    # reads basedir and collects all records/tracks
    def read
      STDOUT.sync = !STDOUT.sync
      record = dir = old = nil
      read_dir(basedir) do |file|
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
