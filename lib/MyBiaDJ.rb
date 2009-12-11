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
require "rainbow"

DB = Sequel.sqlite(File.join(File.dirname(File.dirname(File.expand_path(__FILE__))), "db.sqlite3"))
#                   :logger => [Logger.new($stdout)])

module MyBiaDJ

  Source = File.dirname(File.dirname(File.expand_path(__FILE__)))

  
  $:.unshift File.join(Source, "lib", "MyBiaDJ")
  
  Version = %w[0 1 0]

  VersionSuffix = "alpha"
  
  def self.version
    "MyBiaDJ-" + Version.join(".") + (VersionSuffix and "-#{VersionSuffix}" || "")
  end

  def self.Table(arg)
    arg = arg.to_s.capitalize.to_sym
    MyBiaDJ::Database::Tables.const_get(arg)
  end
  
  def self.config
    @config ||= Config.new
  end

  def self.[](obj)
    config unless @config
    ret = @config[obj]
    ret = ::File.expand_path(ret) if ret[0] == ?~
    ret
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
  def self.Error(*args)
    puts args.map{|a| debug(a, 1).foreground(:red)}.join("\n")
  end
  
end

require "config"
require "helper"
require "exceptions"
require "database"
require "recordcase"
require "records"
require "track"
require "action"
require "interface"
require "virtuals"

require "#{MyBiaDJ::Source}/model/files"
require "#{MyBiaDJ::Source}/model/virtual"

=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end
