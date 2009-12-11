#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

require "lib/MyBiaDJ"

load "tasks/database.rake"

Sequel.extension :migration
Sequel.extension :schema_dumper

# task :migrate do
#   migrator = Sequel::Migrator.apply(DB, File.join(MyBiaDJ::Source, "model"))
#   puts DB.dump_schema_migration
# end

task :lala do
  f = MyBiaDJ::Database::Tables::Files
  a = f.create
  b = f.create

  a.add_parent(b)

  p a
  p a.parent

end

task :lili do
  f = MyBiaDJ::Database::Tables::Virtual.find(:name => "genre", :value => "soundtrack")
  p f.name
  p f.files
end

task :lsdb do
  f = MyBiaDJ::Database::Tables::Files
  f.each do |file|
    if file.parent.respond_to?(:name)
      puts "     > " + "#{file.parent.name} -> #{file.name}".foreground(:cyan)
    else
      puts "  -> #{file.name.underline}"
    end
    puts file.db_record
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
