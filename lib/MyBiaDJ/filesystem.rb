#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ

  class FileSystem

    # superclass
    class Virtual
      def self.name
        self.to_s.split("::").last.downcase.to_sym
      end

      def self.path
        ::File.join(MyBiaDJ[:record_case], name.to_s)
      end

      class Artists < Virtual
      end

      class Albums < Virtual
      end

      class Genres < Virtual
      end
      
      class Tags < Virtual
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
