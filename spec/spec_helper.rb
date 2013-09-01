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

  def path_env_var; 'TELEPATH_PATH'; end
  def test_path; Telepath.root.join 'tmp'; end
  def test_file; test_path.join Telepath::Storage.new.file; end
  def cleanup_db; test_file.delete if test_file.exist?; end
  def assign_test_path; ENV[path_env_var] = test_path.to_s; end
  def unassign_test_path; ENV[path_env_var] = nil; end
  def pre_test_setup; assign_test_path; cleanup_db; end
  def post_test_teardown; unassign_test_path; cleanup_db; end
end

RSpec.configure do |c|
  c.include SpecHelpers
end
