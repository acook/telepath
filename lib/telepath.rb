require 'pathname'

require 'bundler/setup'

require 'telepath/version'
require 'telepath/out'
require 'telepath/storage'
require 'telepath/handler'
require 'telepath/command'

# This is the primary namespace for Telepath
# it's not used for anything except a root-finding function
module Telepath
  def self.root
    Pathname.new(__FILE__).dirname.expand_path.parent
  end
end
