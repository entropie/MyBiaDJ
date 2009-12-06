#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class Track

    class Scrobble < Scrobbler::Track
      def initialize(artist, title)
        super
      end
    end
    
    TagFields = [:artist, :album, :genre_s, :title]
    
    attr_reader :path

    attr_accessor *TagFields

    def initialize(path)
      @path = path
      tags
    end

    def scrobbler
      @scrobbler ||= Scrobble.new(artist, title)
      #p track.tags.map{|t| [t.name,t.count]}.sort_by{|tag,tcount| tcount}.first(10)
    end
    
    def tags
      @tags ||= Mp3Info.open(path) do |mp3|
        TagFields.each do |field|
          send("#{field}=", mp3.tag.send(field))
        end
      end
      p scrobbler.tags.map{|t| [t.name,t.count]}.sort_by{|tag,tcount| tcount}.first(10)
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
