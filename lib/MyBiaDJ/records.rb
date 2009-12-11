#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  # holds all the records
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

  # Record reflects an album/directory
  class Record

    class Tracks < Array
    end

    include FSHelper
    
    attr_reader :tracks, :path

    attr_accessor :db

    def read_from_db
      return unless db
      FSHelper.read_dir(path) do |file|
        tracks << Track.new(file)
      end
      db
    end
    
    def initialize(path)
      @path, @tracks = ::File.expand_path(path), Tracks.new
    end

    # saves entire record and childs
    def save
      files = MyBiaDJ::Table(:files)
      record = files.create(:path => relative_path, :name => name)
      tracks.each do |track|
        track.save(record) if track.mp3?
      end
    end

    # returns tags from last.fm via scrobbler
    def tags
      ttracks = tracks.map{|tt| tt.mp3? and tt.scrobbler.tags.map{|t| [t.name,t.count]}}
      tags = Hash.new{|h,k| h[k] = 0}
      ttracks.each do |track_tags|
        if track_tags
          track_tags.each do |tag,c|
            tags[tag.to_sym] += c.to_i
          end
        end
      end
      tags.sort_by{|h,k| k}.reverse.first(3)
    rescue
      MyBiaDJ::Error("Virtual:Record:#{"Tags".underline}: no infos from remote for #{path}")
      [[:untagged, 100]]
    end

    # returns album name
    # TODO:
    def name
      albums = tracks.map{|t| t.album}.compact
      albums.uniq.size == 1 and albums.first
    end

    alias :album :name
    alias :title :name

    def size
      tracks.size
    end

    # returns album genre
    # TODO:
    def genre
      genres = tracks.map{|t| t.genre}.compact
      genres.uniq.size == 1 and genres.first
    end

    # returns album artist or "Compilation" if there are more than one
    # TODO:
    def artist
      artists = tracks.map{|t| t.artist}.compact
      if artists.uniq.size == 1
        artists.first
      else
        "Compilation"
      end
    end

    # db row of record
    def db_record
      db or MyBiaDJ::Table(:files)[:path => relative_path, :name => name.to_s]
    end
    
    def connect_to(virtual)
      virtual.db_record do |virt|
        db_record.add_virtual(virt)
      end
    rescue
      MyBiaDJ::Error("Virtual:DB:#{virtual.name.to_s.capitalize.underline}: no information found on #{name}")
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
