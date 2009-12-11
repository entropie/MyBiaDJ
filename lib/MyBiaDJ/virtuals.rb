#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class FileSystem

    # imports the entire record-case.
    #
    # this is done by iterating each record, saves the record to the database,
    # iterating each record child and save again. then virtual_for(record) links virtual paths.
    def self.import(recordcase)
      setup_virtuals
      recordcase.records.each do |record|
        record.save
        virtual_for(record) do |virt|
          #p virt.class
        end
      end
    end

    # creates top level directories for virtual
    def self.setup_virtuals
      Virtual.all.map { |v| v.name}.each do |v|
        vpath = ::File.join(::File.expand_path(MyBiaDJ[:record_case]), v.to_s)
        FileUtils.mkdir_p(vpath)
       end
    end

    # links childs and record it to database
    def self.virtual_for(record)
      Virtual.all.each do |virt|
        virt = virt.new(record)
        virt.link!
        virt.connect!
        yield virt if block_given?
      end
    end
    
    # superclass
    class Virtual

      attr_reader :record

      @virtuals = []

      # connects record to virtual (self)
      def connect!
        record.connect_to(self)
      end

      # returns sanitized value
      def value(str)
        sanitize(str)
      end

      # finds/creates virtual entry and yields each record
      def db_record
        vals = [value].flatten
        vals.map do |v|
          record = MyBiaDJ::Table(:virtual).find_or_create(:name => name.to_s, :value => v)
          yield record if block_given?
          record
        end
      end
      
      def root
        ::File.expand_path(MyBiaDJ[:record_case])        
      end
      private :root

      # returns all virtuals
      def self.all
        @virtuals
      end

      # virtual name
      def self.name
        self.to_s.split("::").last.downcase.to_sym
      end

      def name
        self.class.name
      end

      # virtual toplevel path
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
        if str.kind_of?(String)
          str.downcase
        else
          str.map{|s| s.downcase}
        end
      end
      
      def sanitized_virtual_target
        sanitize(virtual_target)
      end

      # returns target for symlink
      def link_target(target = nil)
        ::File.join(self.class.path, sanitized_virtual_target)
      end

      # links
      def link!(target = nil)
        tar = (target or link_target)
        FileUtils.ln_s(record.path, tar, :verbose => MyBiaDJ.debug?)
      rescue
        MyBiaDJ::Error("Virtual:Link:#{name.to_s.capitalize.underline}: skipping #{virtual_target}")
      end

      def virtual_target
        record.name
      end
 
    end
    
 
    attr_reader :record_case
    
    def initialize(path)
      @record_case = ::File.expand_path(path)
    end
  end

  [:genre, :album, :tag, :artist].each do |l|
    require "#{MyBiaDJ::Source}/lib/MyBiaDJ/virtuals/#{l}"
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
