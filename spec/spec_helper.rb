require_relative '../lib/telepath'

require 'rspec'
require 'pry' unless ENV['CI'] == 'true'

Dir.chdir Telepath.root

