#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

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
