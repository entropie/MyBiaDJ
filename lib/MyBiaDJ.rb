#
#
# Author:  Michael 'entropie' Trommer <mictro@gmail.com>
#

require "rubygems"

require "yaml"

require "pow"

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
end

require "config"


=begin
Local Variables:
  mode:ruby
  fill-column:70
  indent-tabs-mode:nil
  ruby-indent-level:2
End:
=end
