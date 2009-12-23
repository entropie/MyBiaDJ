#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

require "lib/MyBiaDJ"

load "tasks/database.rake"

Sequel.extension :migration
Sequel.extension :schema_dumper

task :lala do
  f = MyBiaDJ::Database::Tables::Files
  a = f.create
  b = f.create

  a.add_parent(b)

  p a
  p a.parent

end

task :fuse do
  mirror = MyBiaDJ::FileSystem::Fuse.new
end


task :virtus do
  f = MyBiaDJ::Database::Tables::Virtual
  f.filter(:name => "album").each do |r|
    p r
    #p r.files
  end
end

task :lili do
  f = MyBiaDJ::Database::Tables::Files[10]
  pp f.to_record
end

task :lsdb do
  f = MyBiaDJ::Database::Tables::Files
  f.each do |file|
    if file.parent.respond_to?(:name)
      puts "     > " + "#{file.parent.name} -> #{file.name}".foreground(:cyan)
    else
      puts "  -> #{file.name.underline}"
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
