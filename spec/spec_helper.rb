begin
  require 'coveralls'
  Coveralls.wear!
rescue LoadError
  puts "Couldn't find Coveralls gem, skipping!"
end

require_relative '../lib/telepath'

require 'rspec'
require 'open4'
require 'pry' unless ENV['CI'] == 'true'

Dir.chdir Telepath.root

module SpecHelpers
  def run *args
    result_class = Struct.new :pid, :stdout, :stderr, :commandline, :status
    command = args.join ' '

    result = nil
    status = Open4.open4(command) do |pid, stdin, stdout, stderr|
      result = result_class.new pid, stdout.read, stderr.read, command
    end

    result.status = status
    result
  end

  def capture
    readme, writeme = IO.pipe
    pid = fork do
      $stdout.reopen writeme
      readme.close

      yield
    end

    writeme.close
    output = readme.read
    Process.waitpid(pid)

    output
  end

  def store_unchanged
    expect{ yield }.to change{
      storage.store.adapter.backend.sunrise
      storage.stack.length
    }.by(0)
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
