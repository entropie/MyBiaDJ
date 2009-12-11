#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

module MyBiaDJ::Database::Tables

  class Files < Sequel::Model

    many_to_many :parent, :class => Files, :join_table => :files_relations

    many_to_many  :virtual, :join_table => :files_virtuals

    alias :virtuals :virtual
    
    def parent
      par = super
      return par.kind_of?(Array) ? par.first : nil
    end

    def base_dir
      MyBiaDJ[:record_case]
    end
    
    def to_record
      target =
        if parent then parent else self end

      rc = MyBiaDJ.record_case
      
      fpath = ::File.join(target.base_dir, :direct.to_s, target.path)

      rec = Record.new(fpath)
      rec.db = target
      rec.read_from_db
      rec
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
