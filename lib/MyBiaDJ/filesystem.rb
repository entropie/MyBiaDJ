#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class FileSystem

    def self.import(recordcase)
      recordcase.records.each do |record|
        virtual = select_virtual_for(record)
      end
    end

    def self.select_virtual_for(record)
      Virtual.all.each do |virt|
        v = virt.new(record)
        results = [v.link].flatten
        results.each do |res|
          puts res
        end
        #p v
      end
    end
    
    # superclass
    class Virtual

      attr_reader :record

      @virtuals = []

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

      def sanitized_virtual_target
        virtual_target.downcase
      end

      def link_target(target = nil)
        ::File.join(self.class.path, sanitized_virtual_target, target || record.name)
      end
      
      def link(target = nil)
        "ln -s '#{record.path}' '#{target or link_target}'"
      end

      def virtual_target
        "--"
      end

      class Artist < Virtual
        def virtual_target
          record.artist
        end
      end

      class Album < Virtual
        def link_target(target = nil)
          ::File.dirname(super)
        end
        def virtual_target
          record.name
        end
      end

      class Genre < Virtual
        def virtual_target
          record.genre
        end
      end
      
      class Tag < Virtual
        def link
          record.tags.map do |tag, count|
            super(target = ::File.join(self.class.path, tag.to_s, record.name))
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
