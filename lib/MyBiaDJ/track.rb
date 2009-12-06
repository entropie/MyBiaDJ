#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class Tracks < Array
  end
  
  class Record
    attr_reader :tracks
    
    def initialize(path)
      @path, @tracks = path, Tracks.new
    end

    def name
      albums = tracks.map{|t| t.album}.compact
      albums.uniq.size == 1 and albums.first
    end

    def genre
      genres = tracks.map{|t| t.genre}.compact
      genres.uniq.size == 1 and genres.first
    end

    def artist
      artists = tracks.map{|t| t.artist}.compact
      if artists.uniq.size == 1
        artists.first
      else
        "Compilation"
      end
    end

  end

  class File

    TagFields = [:artist, :album, :genre_s, :title]
    
    attr_reader :path

    attr_accessor *TagFields

    alias :genre :genre_s

    class Scrobble < Scrobbler::Track
      def initialize(artist, title)
        super
      end
      alias :title :name
    end

  end
  

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
