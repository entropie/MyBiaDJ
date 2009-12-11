#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  module FSHelper
    def relative_path(rp = nil)
      (rp||@path).gsub(::File.expand_path(MyBiaDJ[:base_dir]) + "/", '')
    end
  end

  # Record reflects an album/directory
  class Record

    class Tracks < Array
    end

    include FSHelper
    
    attr_reader :tracks, :path

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
      MyBiaDJ::Table(:files)[:path => relative_path, :name => name.to_s]
    end
    
    def connect_to(virtual)
      virtual.db_record do |virt|
        db_record.add_virtual(virt)
      end
    end
    
  end

  # parent class for every file
  class File

    include FSHelper
    
    TagFields = [:artist, :album, :genre_s, :title]
    
    attr_reader :path

    attr_accessor *TagFields

    alias :genre :genre_s
    alias :name :title

    def db_record
      MyBiaDJ::Table(:files)[:name => name.to_s, :path => relative_path]
    end

    # saves track to database and connect it to record
    def save(record)
      track = MyBiaDJ::Table(:files).create(:name => name, :path => relative_path)
      track.add_parent(record)
      track
    end

    def title
      @title
    end
    
    class Scrobble < Scrobbler::Track
      def initialize(artist, title)
        super
      end
      alias :title :name
    end
  end
  

  # track represents a playable file object
  #
  # only mp3s for now
  class Track < File

    def initialize(path)
      @path = path
      set_info_from_mp3
    end

    def mp3?
      path =~ /\.mp3$/i
    end
    
    def scrobbler
      if mp3?
        @scrobbler ||= Scrobble.new(artist, title)
      end
    end

    def inspect
      "#@title"
    end

    # get infos from mp3tags and add as instance_variables
    def set_info_from_mp3
      Mp3Info.open(path) do |mp3|
        TagFields.each do |field|
          send("#{field}=", mp3.tag.send(field))
        end
      end
    rescue
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
