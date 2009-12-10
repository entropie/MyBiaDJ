#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class FileSystem

    def self.import(recordcase)
      setup_virtuals
      recordcase.records.each do |record|
        record.save
        virtual = select_virtual_for(record)
      end
    end

    def self.setup_virtuals
      Virtual.all.map { |v| v.name}.each do |v|
        FileUtils.mkdir_p(::File.join(::File.expand_path(MyBiaDJ[:record_case]), v.to_s))
      end
    end
    
    def self.select_virtual_for(record)
      Virtual.all.each do |virt|
        v = virt.new(record)
        results = [v.link].flatten
        results.each do |res|
          #puts res
        end
      end
    end
    
    # superclass
    class Virtual

      attr_reader :record

      @virtuals = []

      def root
        ::File.expand_path(MyBiaDJ[:record_case])        
      end
      
      def self.all
        @virtuals
      end
      
      def self.name
        self.to_s.split("::").last.downcase.to_sym
      end

      def self.path
        ::File.expand_path(::File.join(MyBiaDJ[:record_case], name.to_s))
      end

      def self.inherited(clz)
        @virtuals << clz
      end
      
      def initialize(record)
        @record = record
      end

      def sanitize(str)
        str.downcase
      end
      
      def sanitized_virtual_target
        sanitize(virtual_target)
      end

      def link_target(target = nil)
        ::File.join(self.class.path, sanitized_virtual_target) #, target || record.name)
      end
      
      def link(target = nil)
        tar = (target or link_target)
        FileUtils.ln_s(record.path, tar, :verbose => MyBiaDJ.debug?)
      end

      def virtual_target
        record.name
      end

      class Artist < Virtual

        def link_target(target = nil)
          artist_path = ::File.join(self.class.path, sanitize(record.artist))
          FileUtils.mkdir_p(artist_path)
          ::File.join(artist_path, sanitize(record.name))
        end
        
      end

      class Album < Virtual

        def link_target(target = nil)
          album_path = ::File.join(self.class.path)
          FileUtils.mkdir_p(album_path)
          ::File.join(album_path, virtual_target)
        end

        def virtual_target
          sanitize(record.name)
        end
      end

      class Genre < Virtual

        def link_target
          genre_path = ::File.join(root, self.class.name.to_s, sanitize(record.genre))
          FileUtils.mkdir_p(genre_path)
          ::File.join(genre_path, sanitize(record.name))
        end
      end
      
      class Tag < Virtual

        def link_target
          record.tags.map do |tag, count|          
            ::File.join(root, self.class.name.to_s, tag.to_s, sanitized_virtual_target)
          end
        end

        def link
          link_target.each do |tagdir|
            FileUtils.mkdir_p(::File.dirname(tagdir))
            FileUtils.ln_s(record.path, tagdir, :verbose => MyBiaDJ.debug?)
          end
        end
        
      end
      
    end

    attr_reader :record_case
    
    def initialize(path)
      @record_case = ::File.expand_path(path)
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
