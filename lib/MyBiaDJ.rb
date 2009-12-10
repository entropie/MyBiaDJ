#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

require "rubygems"

require "yaml"
require "fileutils"
require "pp"

require "pow"
require "sqlite3"
require "sequel"
require "scrobbler"
require "mp3info"

DB = Sequel.sqlite(File.join(File.dirname(File.dirname(File.expand_path(__FILE__))), "db.sqlite3"))

module MyBiaDJ

  Source = File.dirname(File.dirname(File.expand_path(__FILE__)))

  $:.unshift File.join(Source, "lib", "MyBiaDJ")
  
  Version = %w[0 1 0]

  VersionSuffix = "alpha"
  
  def self.version
    "MyBiaDJ-" + Version.join(".") + (VersionSuffix and "-#{VersionSuffix}" || "")
  end

  def self.config
    @config ||= Config.new
  end

  def self.[](obj)
    config unless @config
    @config[obj]
  end

  def self.record_case
    @record_case ||= RecordCase.new(MyBiaDJ[:base_dir])
  end

  def self.filesystem
    @filesystem ||= FileSystem.new(MyBiaDJ[:record_case])
  end
  
  def self.debug?(o = 5)
    MyBiaDJ[:debug] != 0 and MyBiaDJ[:debug] <= o
  end

  def self.debug(arg, lvl)
    "%02i > #{arg}" % lvl
  end
  
  def self.Info(*args)
    puts args.map{|a| debug(a, 3)}.join("\n")
  end
  
end

require "config"
require "exceptions"
require "database"
require "recordcase"
require "track"
require "action"
require "interface"
require "filesystem"

require "#{MyBiaDJ::Source}/model/files"

=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end
