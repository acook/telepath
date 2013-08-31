require_relative '../lib/telepath'

require 'rspec'
require 'open4'
require 'pry' unless ENV['CI'] == 'true'

Dir.chdir Telepath.root

module SpecHelpers
  def run *args
    output = Struct.new :pid, :stdout, :stderr

    status = Open4.popen4(*args) do |pid, stdin, stdout, stderr|
      output = output.new pid, stdout.read, stderr.read
    end

    [status, output]
  end
end

RSpec.configure do |c|
  c.include SpecHelpers
end
