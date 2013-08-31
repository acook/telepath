require 'pathname'

require 'bundler/setup'

require 'telepath/version'

module Telepath
  def self.root
    Pathname.new(__FILE__).dirname.expand_path.parent
  end
end
