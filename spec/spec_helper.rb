require_relative '../lib/telepath'

require 'rspec/core'
require 'rspec/expectations'
require 'bogus/rspec'

require 'pry' unless ENV['CI'] == 'true'

RSpec.configure do |c|
  c.mock_with :bogus
end

Dir.chdir Telepath.root

