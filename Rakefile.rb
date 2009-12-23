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
  f = MyBiaDJ::Database::Tables::Files[10]
  pp f.to_record
end

task :fuse do
  fuse = MyBiaDJ::FileSystem::FuseMirror.new
end

# class PrintChange < FSEvent
#   def on_change(directories)
#     puts "Detected change in: #{directories}"
#   end
  
#   def start
#     puts "watching #{registered_directories.join(", ")} for changes"
#     super
#   end
# end

task :t do
  printer = PrintChange.new
  printer.latency = 0.2
  printer.watch_directories [MyBiaDJ[:record_case]]
  printer.start
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
