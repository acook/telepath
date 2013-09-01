require 'pathname'

require 'bundler/setup'

require 'telepath/version'
require 'telepath/out'
require 'telepath/storage'
require 'telepath/handler'
require 'telepath/command'

module Telepath
  def self.root
    Pathname.new(__FILE__).dirname.expand_path.parent
  end
end
