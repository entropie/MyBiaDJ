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
  p DB.tables
end



=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end
